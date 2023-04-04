const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCopyArray(subsuiteName, input, gasConsumed = []) {
  describe(subsuiteName, function () {
    let testProbeContract;

    before(async function () {
      const testProbeFactory = await ethers.getContractFactory("TestProbe");
      testProbeContract = await testProbeFactory.deploy();

      await testProbeContract.deployed();
    });

    it("Should correctly allocate and copy the array", async function () {
      await testProbeContract.setArray(input.array);
      await testProbeContract.testCopyArray();
    });

    it("Should be more efficient than the reference implementation", async function () {
      const referenceConsumed =
        await testProbeContract.measureReferenceCopyArray(input.array);
      await testProbeContract.setArray(input.array);
      const consumed = await testProbeContract.measureCopyArray();

      expect(consumed).to.be.lessThan(referenceConsumed);
    });

    it(`Should be below the ${input.target} gas consumption target`, async function () {
      await testProbeContract.setArray(input.array);
      const consumed = await testProbeContract.measureCopyArray();
      expect(consumed).to.be.lessThanOrEqual(input.target);
      gasConsumed.push(consumed);
    });
  });
}

module.exports.testCopyArray = testCopyArray;
