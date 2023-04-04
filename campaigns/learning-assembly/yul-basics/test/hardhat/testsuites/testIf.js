const { ethers } = require("hardhat");
const { expect } = require("chai");

// Converts encoded int256 to BigNumber
function intToBN(x) {
  return ethers.BigNumber.from(x).fromTwos(256);
} 

function testIf(subsuiteName, input) {
  describe(subsuiteName, function () {

    before(async function () {
      const IfFactory = await ethers.getContractFactory("If");
      _if = await IfFactory.deploy();
      await _if.deployed();
    });

    it("Should convert minutes to hours", async function () {

      const minutes = intToBN(input);

      if (minutes.lt(ethers.constants.Zero) 
          || minutes.mod(60).eq(ethers.constants.Zero) == false) {

        await expect(_if.minutesToHours(input))
          .to.be.reverted;

      } else {

        expect(await _if.minutesToHours(minutes))
          .to.equal(minutes.div(60));

      }
    });
  });
}

module.exports.testIf = testIf;