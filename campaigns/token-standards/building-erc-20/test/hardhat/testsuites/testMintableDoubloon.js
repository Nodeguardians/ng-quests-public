const { ethers } = require("hardhat");
const { expect } = require("chai");

function testMintableDoubloon(subsuiteName, input) {
  describe(subsuiteName, function () {
    let MintableDoubloonFactory;
    let mdoubloon;

    let creator;
    let user1;

    before(async function () {
      MintableDoubloonFactory =
        await ethers.getContractFactory("MintableDoubloon");

      [creator, user1] = await ethers.getSigners();
    });

    beforeEach(async function () {
      mdoubloon = await MintableDoubloonFactory.deploy(input.supply);
      await mdoubloon.deployed();
    });

    it("Should mint doubloons", async function () {
      
      await mdoubloon.connect(creator)
        .mint(user1.address, input.mintAmount);

      var supply = await mdoubloon.totalSupply();
      var balanceUser1 = await mdoubloon.balanceOf(user1.address);

      expect(supply).to.equal(input.supply + input.mintAmount);
      expect(balanceUser1).to.equal(input.mintAmount);
    });

    it("Should prevent non-creator from minting", async function () {
      let badTx = mdoubloon.connect(user1).mint(
        user1.address, input.mintAmount
      );
      await expect(badTx).to.be.reverted;
    });
  });
}

module.exports.testMintableDoubloon = testMintableDoubloon;