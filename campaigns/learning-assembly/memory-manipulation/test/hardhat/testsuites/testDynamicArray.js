const { expect } = require("chai");
const { ethers } = require("hardhat");

function testDynamicArray(subsuiteName, input) {
  describe(subsuiteName, function () {
    let testProbeContract;

    before(async function () {
      const testProbeFactory = await ethers.getContractFactory("TestProbe");
      testProbeContract = await testProbeFactory.deploy();

      await testProbeContract.deployed();
    });

    it("Should push()", async function () {
      const { array, value } = input.push;

      const expected = array.map((x) => x);
      expected.push(value);

      expect(
        await testProbeContract.testPush(array, value, expected)
      ).to.deep.equal("");
    });

    it("Should pop()", async function () {
      const array = input.pop;

      if (array.length == 0) {
        await expect(testProbeContract.pop(array)).to.be.reverted;
        return;
      }

      const expected = array.map((x) => x);
      expected.pop();
      expect(await testProbeContract.testPop(array, expected)).to.deep.equal(
        ""
      );
    });

    it("Should popAt()", async function () {
      const { array, value: at } = input.popAt;

      if (at >= array.length) {
        await expect(testProbeContract.popAt(array, at)).to.be.reverted;
        return;
      }

      const expected = array.map((x) => x);
      expected.splice(at, 1);
      expect(
        await testProbeContract.testPopAt(array, at, expected)
      ).to.deep.equal("");
    });
  });
}

module.exports.testDynamicArray = testDynamicArray;
