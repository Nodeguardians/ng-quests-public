const { ethers } = require("hardhat");
const { expect } = require("chai");

function testAmuletCreation(subsuiteName, input) {
  describe(subsuiteName, function () {
    let AmuletFactory;
    let amulet;

    let creator;
    let user2;

    const ERC165_ID = "0x01ffc9a7";
    const ERC721_ID = "0x80ac58cd";
    const ERC721_METADATA_ID = "0x5b5e139f";
    const ERC721_TOKEN_RECEIVER_ID = "0x150b7a02";

    before(async function () {
      AmuletFactory = await ethers.getContractFactory("Amulet");

      [creator, user2] = await ethers.getSigners();
      creatorAddress = await creator.getAddress();
      user2Address = await user2.getAddress();
    });

    beforeEach(async function () {
      amulet = await AmuletFactory.deploy();
      await amulet.deployed();
    });

    it("Should have name and symbol", async function () {
      expect(await amulet.name()).to.equal("Amulet");
      expect(await amulet.symbol()).to.equal("AMULET");
    });

    it("Should mint token", async function () {
      const amuletID = await amulet.connect(creator)
        .callStatic.mint(user2.address, input);

      await amulet.connect(creator).mint(user2.address, input.uri);

      expect(amuletID).to.equal(0);
      expect(await amulet.tokenURI(amuletID)).to.equal(input.uri);

      const amuletID2 = await amulet.connect(creator)
        .callStatic.mint(user2.address, input);
      expect(amuletID2).to.equal(1);
    });

    it("Should have ownerOf and balanceOf", async function () {
      await amulet.connect(creator)
        .mint(user2.address, input.uri);
      await amulet.connect(creator)
        .mint(user2.address, input);
      
      expect(await amulet.balanceOf(user2.address)).to.equal(2);
      expect(await amulet.ownerOf(0)).to.equal(user2.address);
      expect(await amulet.ownerOf(1)).to.equal(user2.address);

      await expect(
        amulet.ownerOf(2), "Invalid token should revert"
      ).to.be.reverted;
      await expect(
        amulet.balanceOf(ethers.constants.AddressZero), 
        "Zero address should revert"
      ).to.be.reverted;
    });

    it("Should prevent non-owners from minting", async function () {
      await expect(amulet.connect(user2)
        .mint(creatorAddress, input.uri)).to.be.reverted;
    });

    it("Should revert on invalid token", async function () {
      await expect(amulet.tokenURI(12345)).to.be.reverted;
    });

    it("Should support correct interfaces", async function () {
      expect(await amulet.supportsInterface(ERC165_ID)).to.be.true;
      expect(await amulet.supportsInterface(ERC721_ID)).to.be.true;
      expect(await amulet.supportsInterface(ERC721_METADATA_ID)).to.be.true;
      expect(await amulet.supportsInterface(ERC721_TOKEN_RECEIVER_ID)).to.be.false;
    });

  });
}

module.exports.testAmuletCreation = testAmuletCreation;