const { ethers } = require("hardhat");
const { expect } = require("chai");

function testWhispersV1(subsuiteName, input) {
  describe(subsuiteName, function () {
    let whispersv1;
    let whisperUint256Selector;
    let whisperStringSelector;
    let abiCoder;

    before(async function () {
      const WhispersV1 = await ethers.getContractFactory("WhispersV1");
      whispersv1 = await WhispersV1.deploy();

      whisperUint256Selector = whispersv1.interface.getSighash("whisperUint256")
      whisperStringSelector = whispersv1.interface.getSighash("whisperString")
      abiCoder = new ethers.utils.AbiCoder();

      await whispersv1.deployed();
    });

    it("Should whisperUint256()", async () => {

      for (const value of input.uintValues) {

        const calldata = whisperUint256Selector 
        + abiCoder.encode(["uint256"], [value]).slice(2);

        const resultData = await ethers.provider.call({
          to: whispersv1.address,
          data: calldata
        });

        const result = abiCoder.decode(["uint"], resultData)[0];
        expect(result).to.equal(value);
      }

    });

    it("Should whisperString()", async () => {

      for (const value of input.strValues) {

        const calldata = whisperStringSelector 
          + abiCoder.encode(["string"], [value]).slice(2);

        const resultData = await ethers.provider.call({
          to: whispersv1.address,
          data: calldata
        });

        const result = abiCoder.decode(["string"], resultData)[0];
        
        expect(result).to.equal(value);

      }

    });
  });
}

module.exports.testWhispersV1 = testWhispersV1;