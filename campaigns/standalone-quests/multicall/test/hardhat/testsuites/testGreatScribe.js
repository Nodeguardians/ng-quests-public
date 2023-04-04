const { ethers } = require("hardhat");
const { expect } = require("chai");

function encodeCall(call) {

  const selector = ethers.utils.id(call.sig).slice(0, 10);
  const encodedArgs = call.args.map(x => {
    const hexArg = ethers.BigNumber.from(x).toHexString();
    return ethers.utils.hexZeroPad(hexArg, 32);
  });

  return ethers.utils.hexConcat(
    [selector].concat(encodedArgs)
  )

}

function testGreatScribe(subsuiteName, input) { 
  describe(subsuiteName, function () {

    let signer;
    
    let readCalls;
    let writeCalls;
    
    let expectedReads = [];
    let expectedReturns = [];

    let callee;
    let referenceCallee;
    let scribe;

    before(async function() {
      signer = await ethers.getSigner();

      const Scribe = await ethers.getContractFactory("GreatScribe");
      scribe = await Scribe.deploy();

      await scribe.deployed();

      const Callee = await ethers.getContractFactory(input.callee);
      callee = await Callee.deploy();
      referenceCallee = await Callee.deploy();

      await scribe.deployed();
      await callee.deployed();
      await referenceCallee.deployed();

      readCalls = input.testReads.map(encodeCall);
      writeCalls = input.testWrites.map(encodeCall);

      for (const writeCall of writeCalls) {
        const tx = { to: referenceCallee.address, data: writeCall };
        const result = await ethers.provider.call(tx);
        await signer.sendTransaction(tx);

        expectedReturns.push(result);
      }

      for (const readCall of readCalls) {
        const tx = { to: referenceCallee.address, data: readCall };
        const result = await ethers.provider.call(tx);

        expectedReads.push(result);
      }

    });

    it("Should batch read-only calls in multiread()", async function () {

      const readValues = await scribe.multiread(
        readCalls, 
        referenceCallee.address
      );

      expect(readValues).to.be.deep.equals(expectedReads);

    });


    it("Should revert on failed calls in multiread()", async function () {
      const invalidCalls = input.invalidReads.map(encodeCall);
      await expect(scribe.multiread(invalidCalls, callee.address))
        .to.be.reverted;
    });

    it("Should batch transactions in multiwrite()", async function () {

      const returnValues = await scribe.callStatic.multiwrite(writeCalls, callee.address);
      await scribe.multiwrite(writeCalls, callee.address);

      // Check return values are forwarded correctly
      expect(returnValues).to.be.deep.equals(expectedReturns);

      // Test if functions are called correctly
      for (let i = 0; i < readCalls.length; i++) {
        const tx = { to: referenceCallee.address, data: readCalls[i] };
        const result = await ethers.provider.call(tx);

        expect(result, expectedReads[i], "Unexpected Result");
      }

    });

    it("Should revert on failed calls in multiwrite()", async function () {
      const invalidCalls = input.invalidWrites.map(encodeCall);
      await expect(scribe.multiwrite(invalidCalls, callee.address))
        .to.be.reverted;
    });

  });

}

module.exports.testGreatScribe = testGreatScribe;