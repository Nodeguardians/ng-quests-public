const { ethers } = require("hardhat");
const { expect } = require("chai");

const { approveBlessing, approveInvitation } = require("../scripts/sign.js");
const { blessings, blessingSignatures, invitations } = require("./testdata.js");

describe("Sign Functions", function () {

    let signers;

    before(async function () {
        signers = ethers.getSigners();
    });

    it("Should approve invitations", async function () {

        for (let i = 0; i < invitations.length; i++) {

            let invite = invitations[i];

            let signature = approveInvitation(
                invite.recipient,
                new ethers.Wallet(invite.signingKey)
            );

            expect(await signature).to.be.equals(invite.signature);

        }

    });

    it("Should approve blessings", async function () {

        for (let i = 0; i < blessings.length; i++) {
            let blessing = blessings[i];

            let signature = approveBlessing(
                blessing.recipient,
                blessing.amount,
                blessing.ctr,
                new ethers.Wallet(blessing.signingKey)
            );

            expect(await signature).to.be.equals(blessing.signature);

        }
    });

});