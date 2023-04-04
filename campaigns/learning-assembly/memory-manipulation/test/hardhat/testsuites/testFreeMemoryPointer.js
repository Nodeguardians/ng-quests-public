const { expect } = require("chai");
const { ethers } = require("hardhat");

function testFreeMemoryPointer(subsuiteName, input) {

  describe(subsuiteName, function () {
    let testProbeContract;

    beforeEach(async function () {
      const testProbeFactory = await ethers.getContractFactory("TestProbe");
      testProbeContract = await testProbeFactory.deploy();
      await testProbeContract.deployed();
    });

    it("Should getFreeMemoryPointer()", async () => {
      for (const size of input.freeMemoryPointer.map(ethers.BigNumber.from)) {

        const error = await testProbeContract
          .testGetFreeMemoryPointer(size);

        expect(error).to.deep.equal("");
      }
    });

    it("Should getMaxAccessedAddress()", async () => {
      for (const size of input.maxAccessedMemory.map(ethers.BigNumber.from)) {
        const offset = size.add(size.mod(32))
        const error = await testProbeContract.testGetMaxAccessedMemory(offset);
        expect(error).to.deep.equal("");
      }
    });

    it("Should allocateMemory()", async () => {
      for (const size of input.allocateMemory.map(ethers.BigNumber.from)) {
        const error = await testProbeContract.testAllocateMemory(size);
        expect(error).to.deep.equal("");
      }
    });
    
    it("Should freeMemory()", async () => {
      for (const chunk of input.freeMemory) {
        const { allocated, size } = chunk;

        if (ethers.BigNumber.from(size).gt(allocated)) {
          await expect(testProbeContract.testFreeMemory(allocated, size)).to.be.reverted;
        }
        else {
          const error = await testProbeContract.testFreeMemory(allocated, size);
          expect(error).to.deep.equal("");
        }
      }
    });
    
  });
}

module.exports.testFreeMemoryPointer = testFreeMemoryPointer;