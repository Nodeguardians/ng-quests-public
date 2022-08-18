const { ethers } = require("hardhat");
const { expect } = require("chai");
const { parseEther } = require("ethers/lib/utils");

const { approveBlessing, approveInvitation } = require("../../scripts/sign.js");

function testGrandmasters(input) {
  describe(input.name, function () {

    let grandmasters;

    let creator;
    let recipient;
    let other;

    beforeEach(async function () {

      creator = await input.creator;
      recipient = await input.recipient;
      other = await input.other;

      GrandmastersFactory = await ethers.getContractFactory("Grandmasters");

      grandmasters = await GrandmastersFactory
        .connect(creator)
        .deploy({value: input.amount});

      await grandmasters.deployed();

    });
  
    it("Should initially only have contract creator as grandmaster", async function () {

      let result = await grandmasters.grandmasters(creator.address);
      expect(result).to.be.true;

      result = await grandmasters.grandmasters(recipient.address);
      expect(result).to.be.false;

    });

    it("Should have receiveBlessing() working", async function () {

      // 1. Test first blessing
      let signature = approveBlessing(
        recipient.address, input.amount, 0, creator
      );

      expect(() => 
        grandmasters
          .connect(recipient)
          .receiveBlessing(input.amount, signature)
      ).to.changeEtherBalance(recipient, input.amount);

      // 2. Test replay (should fail)
      let replay = grandmasters
        .connect(recipient)
        .receiveBlessing(input.amount, signature);
      expect(replay).to.be.reverted;

      // 3. Test second blessing (nonce incremented)
      signature = approveBlessing(
        recipient.address, input.amount, 1, creator
      );

      expect(() => 
        grandmasters
          .connect(recipient)
          .receiveBlessing(input.amount, signature)
      ).to.changeEtherBalance(recipient, input.amount);

    });

    it("Should have acceptInvite() working", async function () {

      let signature = approveInvitation(recipient.address, creator);

      await grandmasters
        .connect(recipient)
        .acceptInvite(signature);

      expect(
        await grandmasters.grandmasters(recipient.address)
      ).to.be.true;

      // Test if recipient signature will be accepted
      signature = approveInvitation(
        other.address, recipient);

      await grandmasters
        .connect(other)
        .acceptInvite(signature);

      expect(
        await grandmasters.grandmasters(other.address)
      ).to.be.true;
        
    });

    it("Should not accept invalid signatures", async function () {

      // 1. Test invalid invite signature
      let signature = approveInvitation(recipient.address, other);

      let inviteTx = grandmasters
        .connect(recipient)
        .acceptInvite(signature);

      await expect(inviteTx).to.be.reverted;

      // Test invalid blessing signature
      signature = approveBlessing(
        recipient.address, input.amount, 0, creator
      );

      let illegalAmount = parseEther("100").add(input.amount);
      let blessingTx = grandmasters
        .connect(recipient)
        .receiveBlessing(illegalAmount, signature);
      expect(blessingTx).to.be.reverted;

    });

  });

}
module.exports.testGrandmasters = testGrandmasters;