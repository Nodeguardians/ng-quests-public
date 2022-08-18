const { ethers } = require("hardhat");
const { expect } = require("chai");
const { BN } = require("bn.js");

function toBN(bigNumber) {
  return new BN(bigNumber.toHexString().slice(2), 16);
}

function testMasks(input) {
  describe(input.name, function () {
    before(async function () {
      const MasksFactory = await ethers.getContractFactory("Masks");
      masks = await MasksFactory.deploy();
      await masks.deployed();
    });

    it("Should setMask()", async function () {
      const [value, mask] = input.setMask;
      const result = await masks.setMask(value, mask);
      expect(toBN(result).eq(toBN(value).or(toBN(mask)))).to.be.true;
    });

    it("should clearMask()", async function () {
      const [value, mask] = input.clearMask;
      const result = await masks.clearMask(value, mask);
      expect(toBN(result).eq(toBN(value).and(toBN(mask).notn(256)))).to.be.true;
    });

    it("Should get8BytesAt()", async function () {
      const [value, at] = input.get8BytesAt;
      const expected = ethers.BigNumber.from(
        "0x" +
          toBN(value)
            .and(new BN("FFFFFFFFFFFFFFFF", 16).shln(at * 8)).shrn(at * 8)
            .toString(16)
      );

      expect(await masks.get8BytesAt(value, at)).to.equal(expected);
    });
  });
}

module.exports.testMasks = testMasks;
