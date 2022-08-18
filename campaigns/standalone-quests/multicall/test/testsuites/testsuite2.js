const { ethers } = require("hardhat");
const { expect } = require("chai");

function testSuite2(input) {
  describe(input.name, function () {

    let callee;

    before(async function () {
        let Callee = await ethers.getContractFactory(input.callee);
        callee = await Callee.deploy();
        calleeInterface = callee.interface;

        await callee.deployed();
    });

    it("Should batch transactions in multicall()", async function () {
        
      // Test if functions are called correctly
      // (Should emit expected events)
      let calldata = input.testWrites
        .map(call => 
          calleeInterface.encodeFunctionData(call.sig, call.args)
        )
      let tx = await callee.multicall(calldata);

      for (let verify of input.verifyWrites) {
        let result = await verify.call(callee);
        expect(result).to.equals(verify.result);
      }

      // Test if return values are forwarded correctly

      let actual = await callee
        .callStatic.multicall(calldata);

      let expectedPromises = calldata
        .map((call) => ethers.provider.call({
          to: callee.address, data: call
        }));
      let expected = await Promise.all(expectedPromises);

      expect(actual).to.be.deep.equals(expected);

    });

    it("Should revert on failed calls", async function () {
        await expect(callee.multicall(["0x00000000"])).to.be.reverted;
    });

  });
}

module.exports.testSuite2 = testSuite2;