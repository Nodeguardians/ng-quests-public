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

function testMulticall(subsuiteName, input) { 
  describe(subsuiteName, function () {

    let signer;
    
    let readCalls;
    let writeCalls;

    let expectedReads = [];
    let expectedReturns = [];

    let callee;
    let referenceCallee;

    before(async function() {
      signer = await ethers.getSigner();

      const Callee = await ethers.getContractFactory(input.callee);
      callee = await Callee.deploy();
      referenceCallee = await Callee.deploy();

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

    it("Should batch transactions in multicall()", async function () {

      const returnValues = await callee.callStatic.multicall(writeCalls);
      await callee.multicall(writeCalls);

      // Check return values are forwarded correctly
      expect(returnValues).to.be.deep.equals(expectedReturns);

      // Test if functions are called correctly
      for (let i = 0; i < readCalls.length; i++) {
        const tx = { to: referenceCallee.address, data: readCalls[i] };
        const result = await ethers.provider.call(tx);

        expect(result, expectedReads[i], "Unexpected Result");
      }

    });

    it("Should revert on failed calls in multicall()", async function () {
      const invalidCalls = input.invalidCalls.map(encodeCall);
      await expect(callee.multicall(invalidCalls))
        .to.be.reverted;
    });

  });

}

module.exports.testMulticall = testMulticall;
