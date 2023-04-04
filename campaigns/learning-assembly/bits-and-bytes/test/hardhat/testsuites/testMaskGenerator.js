const { ethers } = require("hardhat");
const { expect } = require("chai");

function testMaskGenerator(subsuiteName, input) {
  describe(subsuiteName, function () {

    let maskGenerator;

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
        expect(await maskGenerator.generateMask(nBytes, at, reversed))
          .to.equal(input.expectedMask);
      }
    });
  });
}

module.exports.testMaskGenerator = testMaskGenerator;
