const { ethers } = require("hardhat");
const { expect } = require("chai");

function testFeltArithmetic(subsuiteName, input) { 
  describe(subsuiteName, function () {

    let feltProbe;

    before(async function () {
      let FeltProbe = await ethers.getContractFactory("FeltProbe");

      feltProbe = await FeltProbe.deploy();
      await feltProbe.deployed();

    });

    it("Should modulo add", async function () {
      for (const test of input.addTests) {
        const call = feltProbe.testAdd(test.x, test.y);
        await expect(call).to.not.be.reverted;
        expect (await call, "Too gas inefficient").to.be.lessThan(120);
      }
    });

    it("Should modulo subtract", async function () {
      for (const test of input.subTests) {
        const call = feltProbe.testAdd(test.x, test.y);
        await expect(call).to.not.be.reverted;
        expect (await call, "Too gas inefficient").to.be.lessThan(160);
      }
    });

    it("Should modulo multiply", async function () {
      for (const test of input.mulTests) {
        const call = feltProbe.testMul(test.x, test.y);
        await expect(call).to.not.be.reverted;
        expect (await call, "Too gas inefficient").to.be.lessThan(120);
      }
    });

    it("Should check equality", async function () {
      for (const test of input.eqTests) {
        const call = feltProbe.testEq(test.x, test.y);
        await expect(call).to.not.be.reverted;
        expect (await call, "Too gas inefficient").to.be.lessThan(30);
      }
    });

    it("Should calculate inverse", async function () {
      for (const x of input.invTests) {
        const call = feltProbe.testInv(x);
        await expect(call).to.not.be.reverted;
        expect (await call, "Too gas inefficient").to.be.lessThan(100000);
      }
    });

  });
}

module.exports.testFeltArithmetic = testFeltArithmetic;