const { ethers } = require("hardhat");
const { expect } = require("chai");

// Converts encoded int256 to BigNumber
function intToBN(x) {
  return ethers.BigNumber.from(x).fromTwos(256);
} 

function testComparisons(subsuiteName, input) {
  describe(subsuiteName, function () {
    before(async function () {
      const ComparisonsFactory = await ethers.getContractFactory("Comparisons");
      comparisons = await ComparisonsFactory.deploy();
      await comparisons.deployed();
    });

    it("isZero() should work", async () => {
      for (const value of input.isZero.map(intToBN)) {
        const expected = value.eq(ethers.constants.Zero);
        expect(await comparisons.isZero(value)).to.equal(expected);
      }
    });

    it("greaterThan() should work", async () => {
      for (let testcase of input.greaterThan) {
        const x = intToBN(testcase.x);
        const y = intToBN(testcase.y);
        const expected = x.gt(y);
        expect(await comparisons.greaterThan(x, y))
          .to.equal(expected);
      }
    });

    it("signedLowerThan() should work", async () => {
      for (const testcase of input.signedLowerThan) {
        const x = intToBN(testcase.x);
        const y = intToBN(testcase.y);
        const expected = x.lt(y);
        expect(await comparisons.signedLowerThan(x, y))
          .to.equal(expected);
      }
    });

    it("isNegativeOrEqualTen() should work", async () => {
      for (const value of input.isNegativeOrEqualTen.map(intToBN)) {
        const expected = value.lt(ethers.constants.Zero) 
          || value.eq(ethers.BigNumber.from('10'));
        expect(await comparisons.isNegativeOrEqualTen(value))
          .to.equal(expected);
      }
    });

    it("isInRange() should work", async () => {
      for (const testcase of input.isInRange) {
        const x = intToBN(testcase.x);
        const y = intToBN(testcase.y);
        const z = intToBN(testcase.z);
        const expected = x.gte(y) && x.lte(z);
        expect(await comparisons.isInRange(x, y, z))
          .to.equal(expected);
      }
    });
  });
}

module.exports.testComparisons = testComparisons;