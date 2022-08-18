const { ethers } = require("hardhat");
const { expect } = require("chai");
const { BN } = require("bn.js");

function generateMask(nBytes, at, reversed) {
  let mask = new BN(
    "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF",
    16
  );

  mask = mask.shrn(256 - 8 * nBytes);
  mask = mask.shln(8 * at);

  if (reversed) {
    mask = mask.notn(256);
  }

  return "0x" + mask.toString(16);
}

function testMaskGenerator(input) {
  describe(input.name, function () {
    before(async function () {
      const MaskGeneratorFactory = await ethers.getContractFactory(
        "MaskGenerator"
      );
      maskGenerator = await MaskGeneratorFactory.deploy();
      await maskGenerator.deployed();
    });

    it("Should generateMask()", async function () {
      const nBytes = input.nBytes;
      const at = input.at;
      const reversed = input.reversed;

      if (nBytes + at > 32) {
        await expect(maskGenerator.generateMask(nBytes, at, reversed)).to.be
          .reverted;
      } else {
        const expected = ethers.BigNumber.from(
          generateMask(nBytes, at, reversed)
        );
        expect(await maskGenerator.generateMask(nBytes, at, reversed)).to.equal(
          expected
        );
      }
    });
  });
}

module.exports.testMaskGenerator = testMaskGenerator;
