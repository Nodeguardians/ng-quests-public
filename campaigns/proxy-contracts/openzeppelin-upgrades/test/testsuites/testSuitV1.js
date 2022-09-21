const { ethers, upgrades } = require("hardhat");
const { expect } = require("chai");

function testSuitV1(input) {
  describe(input.name, function () {

    let users;
    let pilotAddresses;
    let suit;

    let ctr = 0;
    let targets = {};

    async function testCreate(sender, target, dmg, reverted) {
      let tx = suit
      .connect(sender)
      .createBomb(target.address, dmg);

      if (reverted) {
        await expect(tx).to.be.reverted;
      } else {
        targets[ctr] = target.address;
        await expect(tx)
          .to.emit(suit, "Transfer")
          .withArgs(ethers.constants.AddressZero, suit.address, ctr++);
      }

    }

    async function testConfirm(sender, bombId, reverted) {
      let tx = suit
        .connect(sender)
        .confirmBomb(bombId);

      if (reverted) {
        await expect(tx).to.be.reverted;
      } else {
        await expect(tx)
          .to.emit(suit, "Transfer")
          .withArgs(suit.address, targets[bombId], bombId);
      }

    }

    beforeEach(async function () {
      users = await ethers.getSigners();
      pilotAddresses = input.pilotIds.map(id => users[id].address);

      const Suit = await ethers.getContractFactory("UltimateSuitV1");

      suit = await upgrades.deployProxy(Suit, pilotAddresses);
      await suit.deployed();
    });

    it("Should have ERC721 name and symbol", async function () {
      expect(await suit.name()).to.equal("Ultimate Suit");
      expect(await suit.symbol()).to.equal("SUIT");
    });

    it("Should resist re-initialization", async function () {
      await expect(suit.initialize(pilotAddresses[0], pilotAddresses[1]))
        .to.be.reverted;
    }); 

    it("Should getPilots()", async function () {
      expect(await suit.getPilots())
        .to.deep.equal(pilotAddresses);
    }); 

    it("Should create and confirm bombs", async function () {
      for (const step of input.steps) {
        step.action == "createBomb"
          ? await testCreate(users[step.senderId], users[step.targetId], step.dmg, step.reverted)
          : await testConfirm(users[step.senderId], step.bombId, step.reverted);
      }
    });

  });

}

module.exports.testSuitV1 = testSuitV1;