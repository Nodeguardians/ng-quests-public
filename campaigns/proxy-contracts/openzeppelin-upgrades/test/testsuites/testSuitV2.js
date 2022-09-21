const { ethers, upgrades } = require("hardhat");
const { expect } = require("chai");

function testSuitV2(input) {
  describe(input.name, function () {

    let users;
    let pilotAddresses;
    let suit;

    let ctr = 0;
    let targets = {};
    let transfersLeft = {};

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

        transfersLeft[bombId] = 2; // After initial transfer, transfers left should be 2
      }

    }

    async function testTransfer(sender, receiver, bombId, reverted) {
      let tx = suit
        .connect(sender)
        .transferFrom(sender.address, receiver.address, bombId);

      if (reverted) {
        await expect(tx).to.be.reverted;
      } else {
        await expect(tx)
          .to.emit(suit, "Transfer")
          .withArgs(sender.address, receiver.address, bombId);
        
        transfersLeft[bombId]--;
        if (transfersLeft[bombId] == 0) {
          await expect(tx)
            .to.emit(suit, "Detonate")
            .withArgs(bombId);
        }
      }

    }

    beforeEach(async function () {
      users = await ethers.getSigners();
      pilotAddresses = input.pilotIds.map(id => users[id].address);

      const SuitV1 = await ethers.getContractFactory("UltimateSuitV1");

      suit = await upgrades.deployProxy(SuitV1, pilotAddresses);
      await suit.deployed();

    });

    it("Should have ERC721 name and symbol", async function () {
      const SuitV2 = await ethers.getContractFactory("UltimateSuitV2");
      suit = await upgrades.upgradeProxy(suit.address, SuitV2);
      await suit.deployed();
      
      expect(await suit.name()).to.equal("Ultimate Suit");
      expect(await suit.symbol()).to.equal("SUIT");
    });

    it("Should getPilots()", async function () {
      const SuitV2 = await ethers.getContractFactory("UltimateSuitV2");
      suit = await upgrades.upgradeProxy(suit.address, SuitV2);
      await suit.deployed();

      expect(await suit.getPilots())
        .to.deep.equal(pilotAddresses);
    });

    it("Should create, confirm and transfer bombs", async function () {
      for (const step of input.steps) {
        if (step.action == "upgrade") {
          const SuitV2 = await ethers.getContractFactory("UltimateSuitV2");
          suit = await upgrades.upgradeProxy(suit.address, SuitV2);
        } else if (step.action == "createBomb") {
          await testCreate(users[step.senderId], users[step.targetId], step.dmg, step.reverted)
        } else if (step.action == "confirmBomb") {
          await testConfirm(users[step.senderId], step.bombId, step.reverted);
        } else { // step.action == "transferBomb"
          await testTransfer(users[step.senderId], users[step.receiverId], step.bombId, step.reverted);
        }
      }
    });

  });

}

module.exports.testSuitV2 = testSuitV2;