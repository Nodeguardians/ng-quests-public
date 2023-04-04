const { ethers } = require("hardhat");
const { expect } = require("chai");

function testSwitch(subsuiteName, inputs) {
  describe(subsuiteName, function () {
    before(async function () {
      const SwitchFactory = await ethers.getContractFactory("Switch");
      _switch = await SwitchFactory.deploy();
      await _switch.deployed();
    });

    it("getDirection() should work", async function () {

      const directions = ["0x6c65667400000000", "0x7269676874000000", "0x666f727761726400", "0x6261636b77617264"];

      for (const id of inputs) {
        const expected = directions[ethers.BigNumber.from(id)
          .mod(ethers.BigNumber.from(4)).toNumber()];

        expect(await _switch.getDirection(id)).to.equal(expected);
      }
    });
  });
}

module.exports.testSwitch = testSwitch;
