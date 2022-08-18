const { ethers } = require("hardhat");
const { expect } = require("chai");

const { approveBlessing, approveInvitation } = require("../../scripts/sign.js");

function testApproveInvitation(input) {
  describe(input.name, function () {

    it("Should approve invitation", async function () {

      let signature = approveInvitation(
          input.recipient,
          new ethers.Wallet(input.signingKey)
      );

      expect(await signature).to.be.equals(input.signature);

    });

  });
}

function testApproveBlessing(input) {
  describe(input.name, function () {
    it("Should approve blessing", async function () {

      let signature = approveBlessing(
        input.recipient,
        input.amount,
        input.ctr,
        new ethers.Wallet(input.signingKey)
      );

      expect(await signature).to.be.equals(input.signature);

    });
  });
}

module.exports.testApproveInvitation = testApproveInvitation;
module.exports.testApproveBlessing = testApproveBlessing;