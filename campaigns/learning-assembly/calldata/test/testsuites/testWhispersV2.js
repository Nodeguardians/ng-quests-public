const { ethers } = require("hardhat");
const { expect } = require("chai");

function testWhispersV2(input) {
  describe(input.name, function () {
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

    it("Should compressedWhisper()", async () => {

      let calldata = whisperSelector;
      
      const bigValues = input.values.map(ethers.BigNumber.from);

      for (const value of bigValues) {
        let valueString = value.toHexString();
        let size = ethers.BigNumber.from(
          (valueString.length - 2) / 2
        );

        calldata += size.toHexString().slice(2) + valueString.slice(2);
      }

      const resultData = await ethers.provider.call({
        to: whispersV2.address,
        data: calldata
      });

      const result = abiCoder.decode(["uint[]"], resultData)[0];
      expect(result).to.deep.equal(bigValues);
    });
  });
}

module.exports.testWhispersV2 = testWhispersV2;