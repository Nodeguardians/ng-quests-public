const { ethers } = require("hardhat");
const { expect } = require("chai");

function testSuite1(input) { 
  describe(input.name, function () {

    let callee;
    let calleeInterface;

    let scribe;

    beforeEach(async function () {
      let Callee = await ethers.getContractFactory(input.callee);
      callee = await Callee.deploy();
      calleeInterface = callee.interface;
  
      let Scribe = await ethers.getContractFactory("GreatScribe");
      scribe = await Scribe.deploy();

      await callee.deployed();
      await scribe.deployed();
    });

    it("Should batch read-only calls in multiread()", async function () {

      await input.beforeRead(callee);

      let calldata = input.testReads
      .map(call => 
        calleeInterface.encodeFunctionData(call.sig, call.args)
      )

      let actual = await scribe.multiread(calldata, callee.address);

      let expectedPromises = calldata
        .map((call) => ethers.provider.call({
          to: callee.address, data: call
        }));
      let expected = await Promise.all(expectedPromises);

      expect(actual).to.be.deep.equals(expected);

    });

    it("Should revert on failed calls in multiread()", async function () {
      await expect(scribe.multiread(["0x00000000"], callee.address)).to.be.reverted;
    });

    it("Should batch transactions in multiwrite()", async function () {

      // Test if functions are called correctly
      // (Should emit expected events)
      let calldata = input.testWrites
        .map(call => 
          calleeInterface.encodeFunctionData(call.sig, call.args)
        )
      let tx = await scribe.multiwrite(calldata, callee.address);

      for (let verify of input.verifyWrites) {
        let result = await verify.call(callee);
        expect(result).to.equals(verify.result);
      }

      // Test if return values are forwarded correctly

      let actual = await scribe
        .callStatic.multiwrite(calldata, callee.address);

      let expectedPromises = calldata
        .map((call) => ethers.provider.call({
          to: callee.address, data: call
        }));
      let expected = await Promise.all(expectedPromises);

      expect(actual).to.be.deep.equals(expected);

    });

    it("Should revert on failed calls in multiwrite()", async function () {
      await expect(scribe.multiwrite(["0x00000000"], callee.address)).to.be.reverted;
    });

  });
}

module.exports.testSuite1 = testSuite1;