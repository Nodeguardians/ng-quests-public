const { ethers } = require("hardhat");
const { expect } = require("chai");

function testMasks(subsuiteName, input) {
  describe(subsuiteName, function () {

    let masks;
    
    before(async function () {
      const MasksFactory = await ethers.getContractFactory("Masks");
      masks = await MasksFactory.deploy();
      await masks.deployed();
    });

    it("Should setMask()", async function () {
      const result = await masks.setMask(
        input.setMask.value, 
        input.setMask.mask
      );

      expect(result).to.equal(input.setMask.expected);
    });

    it("should clearMask()", async function () {
      const result = await masks.clearMask(
        input.clearMask.value, 
        input.clearMask.mask
      );

      expect(result).to.equal(input.clearMask.expected);
    });

    it("Should get8BytesAt()", async function () {
      const result = await masks.get8BytesAt(
        input.get8BytesAt.value, 
        input.get8BytesAt.at
      );

      expect(result).to.equal(input.get8BytesAt.expected);
    });
  });
}

module.exports.testMasks = testMasks;
