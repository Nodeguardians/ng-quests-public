const { ethers } = require("hardhat");
const { expect } = require("chai");

// Converts encoded int256 to BigNumber
function intToBN(x) {
  return ethers.BigNumber.from(x).fromTwos(256);
} 

// Returns true if BigNumber `x` is in range of int256. False otherwise.
function inBounds(x) {
  return x.gte(ethers.constants.MinInt256) 
    && x.lte(ethers.constants.MaxInt256);
}

function testSafeMath(subsuiteName, input) {

  describe(subsuiteName, function () {
    before(async function () {
      const SafeMathFactory = await ethers.getContractFactory("SafeMath");

      safeMath = await SafeMathFactory.deploy();

      await safeMath.deployed();
    });

    it("Should add", async function () {
      const x = intToBN(input.add.x);
      const y = intToBN(input.add.y);

      const result = x.add(y);
      if (inBounds(result)) {
        expect(await safeMath.add(x, y)).to.equal(result);
      } else {
        await expect(safeMath.add(x, y)).to.be.reverted;
      }
    });

    it("Should subtract", async function () {
      const x = intToBN(input.sub.x);
      const y = intToBN(input.sub.y);

      const result = x.sub(y);
      if (inBounds(result)) {
        expect(await safeMath.sub(x, y)).to.equal(result);
      } else {
        await expect(safeMath.sub(x, y)).to.be.reverted;
      }
    });

    it("Should multiply", async function () {
      const x = intToBN(input.mul.x);
      const y = intToBN(input.mul.y);

      const result = x.mul(y);
      if (inBounds(result)) {
        expect(await safeMath.mul(x, y)).to.equal(result);
      } else {
        await expect(safeMath.mul(x, y)).to.be.reverted;
      }
    });

    it("Should divide", async function () {
      const x = intToBN(input.div.x);
      const y = intToBN(input.div.y);

      if (y.eq(ethers.constants.Zero)) {
        await expect(safeMath.div(x, y)).to.be.reverted;
        return;
      }

      const result = x.div(y);
      if (inBounds(result)) {
        expect(await safeMath.div(x, y)).to.equal(result);
      } else {
        await expect(safeMath.div(x, y)).to.be.reverted;
      }
    });
  });
}

module.exports.testSafeMath = testSafeMath;