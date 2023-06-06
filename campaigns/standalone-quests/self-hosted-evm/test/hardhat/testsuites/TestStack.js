const { ethers } = require("hardhat");
const { expect } = require("chai");

function testStack(subsuiteName) {
  describe(subsuiteName, function () {
    let testProbe;

    before(async function () {
      const testProbeFactory = await ethers.getContractFactory(
        "TestProbeStack"
      );
      testProbe = await testProbeFactory.deploy();
      await testProbe.deployed();
    });

    it("Should correctly push and peek values in the stack", async function () {
      await testProbe._testPushAndPeek();
    });

    it("Should not push values onto the stack if the stack is full", async function () {
      await expect(testProbe._testPushFullStack()).to.be.revertedWith(
        "sEVM: stack is full"
      );
    });

    it("Should not peek values on the stack if the stack is empty", async function () {
      await expect(testProbe._testPeekEmptyStack()).to.be.revertedWith(
        "sEVM: stack is empty"
      );
    });

    it("Should not peek values on the stack if the peek index is out of range", async function () {
      await expect(testProbe._testPeekOutOfRange()).to.be.revertedWith(
        "sEVM: stack out of bounds"
      );
    });
    
    it("Should correctly pop values off the stack", async function () {
      await testProbe._testPop();
    });

    it("Should not pop values off the stack if the stack is empty", async function () {
      await expect(testProbe._testPopEmptyStack()).to.be.revertedWith(
        "sEVM: stack is empty"
      );
    });

    it("Should correctly swap values on the stack", async function () {
      await testProbe._testSwap();
    });

    it("Should not swap values on the stack if the stack is empty", async function () {
      await expect(testProbe._testSwapEmptyStack()).to.be.revertedWith(
        "sEVM: stack is empty"
      );
    });

    it("Should not swap values on the stack if the swap index is out of range", async function () {
      await expect(testProbe._testSwapOutOfRange()).to.be.revertedWith(
        "sEVM: stack out of bounds"
      );
    });

  });
}

module.exports = {
  testStack,
};
