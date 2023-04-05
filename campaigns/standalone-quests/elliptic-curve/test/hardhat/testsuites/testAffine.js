const { ethers } = require("hardhat");
const { expect } = require("chai");

function testAffine(subsuiteName, input) {
  describe(subsuiteName, function () {

    let curveProbe;

    before(async function () {
      let CurveProbe = await ethers.getContractFactory("CurveProbe");

      curveProbe = await CurveProbe.deploy();
      await curveProbe.deployed()
    });

    it("Should convert Affine => Jacobian", async function () {
      for (const test of input.affToJacTests) {
        const call = curveProbe.testAffineToJac(test.x, test.y);

        await expect(call).to.not.be.reverted;
        expect(await call, "Too gas inefficient").to.be.lessThan(400);
      }
    });

    it("Should convert Jacobian => Affine", async function () {
      for (const test of input.jacToAffTests) {

        const call = curveProbe.testJacToAffine(test.P);
        await expect(call).to.not.be.reverted;
        expect(await call, "Too gas inefficient").to.be.lessThan(80000);
      }
    });
    
  });

}

module.exports.testAffine = testAffine;