const { ethers } = require("hardhat");
const { expect } = require("chai");

function testWhispersV2(subsuiteName, input) {
  describe(subsuiteName, function () {
    let whispersV2;
    let whisperSelector;
    let abiCoder;

    before(async function () {
      const WhispersV2 = await ethers.getContractFactory("WhispersV2");
      whispersV2 = await WhispersV2.deploy();

      whisperSelector = 
        whispersV2.interface.getSighash("compressedWhisper");
      abiCoder = new ethers.utils.AbiCoder();

      await whispersV2.deployed();
    });

    it("Should uncompress whisper", async () => {

      const resultData = await ethers.provider.call({
        to: whispersV2.address,
        data: whisperSelector + input.compressed.slice(2)
      });

      const result = abiCoder.decode(["uint[]"], resultData)[0];
      expect(result).to.deep.equal(input.uncompressed);
    });
  });
}

module.exports.testWhispersV2 = testWhispersV2;