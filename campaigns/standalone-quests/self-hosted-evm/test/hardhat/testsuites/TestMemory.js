const { ethers } = require("hardhat");
const { expect } = require("chai");

function testMemory(subsuiteName) {
  describe(subsuiteName, function () {
    let testProbe;

    before(async function () {
      const testProbeFactory = await ethers.getContractFactory(
        "TestProbeMemory"
      );
      testProbe = await testProbeFactory.deploy();
      await testProbe.deployed();
    });

    it("Should correctly store and load a value in memory", async function () {
      await testProbe._testStoreAndLoad();
    });

    it("Should not allow to store a value in memory if the offset is out of range", async function () {
      await expect(testProbe._testStoreOutOfRange()).to.be.revertedWith(
        "sEVM: memory out of bounds"
      );
    });

    it("Should correctly store8 a value in memory", async function () {
      await testProbe._testStore8();
    });

    it("Should not allow to store8 a value in memory if the offset is out of range", async function () {
      await expect(testProbe._testStore8OutOfRange()).to.be.revertedWith(
        "sEVM: memory out of bounds"
      );
    });

    it("Should not allow to load a value from memory if the offset is out of range", async function () {
      await expect(testProbe._testLoadOutOfRange()).to.be.revertedWith(
        "sEVM: memory out of bounds"
      );
    });

    it("Should correctly inject some data in memory", async function () {
      await testProbe._testInject();
    });

    it("Should not allow to inject some data in memory if the offset is out of range", async function () {
      await expect(testProbe._testInjectOutOfRange()).to.be.revertedWith(
        "sEVM: memory out of bounds"
      );
    });

    it("Should correctly extract some data from memory", async function () {
      await testProbe._testExtract();
    });

    it("Should not allow to extract some data from memory if the offset is out of range", async function () {
      await expect(testProbe._testExtractOutOfRange()).to.be.revertedWith(
        "sEVM: memory out of bounds"
      );
    });
  });
}

module.exports = {
  testMemory,
};
