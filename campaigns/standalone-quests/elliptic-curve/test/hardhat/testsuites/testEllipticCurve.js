const { ethers } = require("hardhat");
const { expect } = require("chai");

function testCurveOperations(subsuiteName, input) {
  describe(subsuiteName, function () {

    let curveProbe;

    before(async function () {
      let CurveProbe = await ethers.getContractFactory("CurveProbe");

      curveProbe = await CurveProbe.deploy();
      await curveProbe.deployed()

    });

    it("Should add unique points", async function () {
      
      for (const test of input.addTests) {
        const call = curveProbe.testAdd(test.P, test.Q, test.R)
        await expect(call).to.not.be.reverted;
        expect(await call, "Too gas inefficient").to.be.lessThan(3000);
      }

    });

    it("Should double identical points", async function () {

      for (const test of input.doubleTests) {
        const call = curveProbe.testAdd(test.P1, test.P2, test.Q);
        await expect(call).to.not.be.reverted;
        expect(await call, "Too gas inefficient").to.be.lessThan(3400);
      }

    });

    it("Should multiply points", async function () {

      for (const test of input.mulTests) {
        const call = curveProbe.testMul(test.k, test.P, test.Q);
        await expect(call).to.not.be.reverted;
        expect(await call, "Too gas inefficient").to.be.lessThan(1200000);
      }

    });

    it("Should generate points", async function () {

      for (const test of input.genTests) {
        const call = curveProbe.testGen(test.k, test.P);
        await expect(call).to.not.be.reverted;
        expect(await call, "Too gas inefficient").to.be.lessThan(1200000);
      }

    });

  });

}

module.exports.testCurveOperations = testCurveOperations;