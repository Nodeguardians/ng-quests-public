const { ethers } = require("hardhat");
const { expect } = require("chai");

function testScrambled(subsuiteName, input) {
  describe(subsuiteName, function () {

    let scrambledContract;

    before(async function () {
      const ScrambledFactory = await ethers.getContractFactory("Scrambled");
      scrambledContract = await ScrambledFactory.deploy();
      await scrambledContract.deployed();
    });

    it("Should recoverAddress()", async function () {
      const result = await scrambledContract.recoverAddress(input.scrambled);
      expect(result).to.equal(input.unscrambled);
    });
  });
}

module.exports.testScrambled = testScrambled;