const { ethers } = require("hardhat");
const { expect } = require("chai");

function testBitOperators(input) {

  describe(input.name, function () {
    before(async function () {
      const BitOperatorsFactory = await ethers.getContractFactory(
        "BitOperators"
      );

      bitOperators = await BitOperatorsFactory.deploy();
      await bitOperators.deployed();
    });

    it("Should shiftLeft()", async function () {
      const [value, shift] = input.shiftLeft.map(ethers.BigNumber.from);
      const expected = value.shl(shift.toNumber()).mod(ethers.constants.MaxUint256.add(1));
      expect(await bitOperators.shiftLeft(value, shift)).to.equal(expected);
    });

    it("Should shiftRight()", async function () {
      const [value, shift] = input.shiftRight.map(ethers.BigNumber.from);
      const expected = value.shr(shift.toNumber()).mod(ethers.constants.MaxUint256.add(1));
      expect(await bitOperators.shiftRight(value, shift)).to.equal(expected);
    });

    it("Should setBit()", async function () {
      const [value, index] = input.setBit.map(ethers.BigNumber.from);
      const expected = value.or(ethers.constants.Two.pow(index));
      expect(await bitOperators.setBit(value, index)).to.equal(expected);
    });

    it("Should clearBit()", async function() {
      const [value, index] = input.clearBit.map(ethers.BigNumber.from);
      const expected = value.and(ethers.constants.MaxUint256.sub(ethers.constants.Two.pow(index)));
      expect(await bitOperators.clearBit(value, index)).to.equal(expected);
    });

    it("Should flipBit()", async function () {
      const [value, index] = input.flipBit.map(ethers.BigNumber.from);

      const expected = value.xor(ethers.constants.Two.pow(index));
      expect(await bitOperators.flipBit(value, index)).to.equal(expected);
    });

    it("Should getBit()", async function () {
      let [value, index] = input.getBit;
      value = ethers.BigNumber.from(value);

      const expected = value.shr(index).and(ethers.constants.One);
      expect(await bitOperators.getBit(value, index)).to.equal(expected);
    });
  });
}

module.exports.testBitOperators = testBitOperators;