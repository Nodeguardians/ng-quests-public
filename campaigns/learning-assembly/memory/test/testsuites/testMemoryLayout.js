const { ethers } = require("hardhat");
const { expect } = require("chai");

function testMemoryLayout(input) {
  describe(input.name, function () {
    let testProbeContract;

    before(async function () {
      const testProbeFactory = await ethers.getContractFactory("TestProbe");
      testProbeContract = await testProbeFactory.deploy();
      await testProbeContract.deployed();
    });

    it("Should createUint256Array()", async function () {
      const [size, value] = input.createUint256Array;
      let error = await testProbeContract.testCreateUint256Array(size, value);
      expect(error).to.deep.equal("");
    })

    it("Should createBytesArray()", async function () {
      const [size, value] = input.createBytesArray;
      let error = await testProbeContract.testCreateBytesArray(size, value);
      expect(error).to.deep.equal("");
    })
  });
}

module.exports.testMemoryLayout = testMemoryLayout;