const { ethers } = require("hardhat");
const { expect } = require("chai");

function unwrapValueIndexPair(pair) {
  return [
    ethers.BigNumber.from(pair.x.toString()),
    pair.y
  ];
}

function testBitOperators(subsuiteName, input) {

  describe(subsuiteName, function () {

    let bitOperators;

    before(async function () {
      const BitOperatorsFactory = await ethers.getContractFactory(
        "BitOperators"
      );

      bitOperators = await BitOperatorsFactory.deploy();
      await bitOperators.deployed();
    });

    it("Should shiftLeft()", async function () {
      const [value, shift] = unwrapValueIndexPair(input.shiftLeft);

      const expected = value.shl(shift)
        .mod(ethers.constants.MaxUint256.add(1));

      expect(await bitOperators.shiftLeft(value, shift)).to.equal(expected);
    });

    it("Should setBit()", async function () {
      const [value, index] = unwrapValueIndexPair(input.setBit);
      const expected = value.or(ethers.constants.Two.pow(index));
      expect(await bitOperators.setBit(value, index)).to.equal(expected);
    });

    it("Should clearBit()", async function() {
      const [value, index] = unwrapValueIndexPair(input.clearBit);

      const expected = value.and(ethers.constants.MaxUint256.sub(ethers.constants.Two.pow(index)));
      expect(await bitOperators.clearBit(value, index)).to.equal(expected);
    });

    it("Should flipBit()", async function () {
      const [value, index] = unwrapValueIndexPair(input.flipBit);

      const expected = value.xor(ethers.constants.Two.pow(index));

      expect(await bitOperators.flipBit(value, index)).to.equal(expected);
    });

    it("Should getBit()", async function () {
      const [value, index] = unwrapValueIndexPair(input.getBit);
      const expected = value.shr(index).and(ethers.constants.One);
      expect(await bitOperators.getBit(value, index)).to.equal(expected);
    });
  });
}

module.exports.testBitOperators = testBitOperators;