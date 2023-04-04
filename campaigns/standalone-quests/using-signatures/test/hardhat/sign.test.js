const { assert, expect } = require("chai");
const hashData = require("../data/hashes.json");

describe("Writing signatures (Part 1)", function() {

  describe("Public Test 1", function () {

    it("Should sign invites", async function () {

      let inviteSignatures;
      try {
        inviteSignatures = require("../../output/invites.json");
      } catch {
        assert(false, "Failed to open output/invites.json");
      }

      for (let i = 0; i < hashData["invite-hashes"].length; i++) {
        expect(ethers.utils.keccak256(inviteSignatures[i]))
          .to.equal(hashData["invite-hashes"][i]); 
      }

    });

  });

  describe("Public Test 2", function () {

    it("Should sign blessings", async function () {

      let blessingSignatures;
      try {
        blessingSignatures = require("../../output/blessings.json");
      } catch {
        assert(false, "Failed to open output/blessings.json");
      }

      for (let i = 0; i < hashData["blessing-hashes"].length; i++) {
        expect(ethers.utils.keccak256(blessingSignatures[i]))
          .to.equal(hashData["blessing-hashes"][i]); 
      }

    });

  });
});