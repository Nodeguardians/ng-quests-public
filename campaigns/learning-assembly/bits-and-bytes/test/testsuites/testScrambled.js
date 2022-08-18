const { ethers } = require("hardhat");
const { expect } = require("chai");

function testScrambled(input) {
  describe(input.name, function () {
    before(async function () {
      const ScrambledFactory = await ethers.getContractFactory("Scrambled");
      scrambledContract = await ScrambledFactory.deploy();
      await scrambledContract.deployed();
    });

    it("Should recoverAddress()", async function () {
      const part1 = input.address.slice(2, 18);
      const part2 = input.address.slice(18, 30);
      const part3 = input.address.slice(30, 42);

      const scrambled =
        "0x00" + part3 + "0000000000000000" + part2 + "0000" + part1 + "00";

      expect((await scrambledContract.recoverAddress(scrambled)).toLowerCase()).to.equal(
        input.address.toLowerCase()
      );
    });
  });
}

module.exports.testScrambled = testScrambled;