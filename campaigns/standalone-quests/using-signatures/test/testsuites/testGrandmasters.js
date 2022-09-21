const { ethers } = require("hardhat");
const { expect } = require("chai");

function testGrandmasters(input) {

  let grandmasters;
  let accounts;

  before(async function () {

    accounts = await ethers.getSigners();

    GrandmastersFactory = await ethers.getContractFactory("Grandmasters");

    grandmasters = await GrandmastersFactory
      .connect(accounts[input.creatorId])
      .deploy({value: "10000000000000000000"});

    await grandmasters.deployed();

  });

  it(input.hint, async function () {

    for (const step of input.steps) {

      if (step.action == "invite") {

        let recipient = accounts[step.recipientId];

        let tx = grandmasters
          .connect(recipient)
          .acceptInvite(step.signature);

        if (step.reverted) {
          await expect(tx).to.be.reverted;
        } else {

          await expect(tx).to.not.be.reverted;

          const isGrandmaster = await grandmasters.grandmasters(recipient.address)
          expect(isGrandmaster).to.be.true;

        }

      } else {

        let recipient = accounts[step.recipientId];

        let tx = grandmasters
          .connect(recipient)
          .receiveBlessing(step.amount, step.signature);

        if (step.reverted) {
          await expect(tx).to.be.reverted;
        } else {
          await expect(tx).to.changeEtherBalance(recipient, step.amount);
        }

      }

    }
  });

}
module.exports.testGrandmasters = testGrandmasters;