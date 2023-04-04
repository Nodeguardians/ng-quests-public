const { assert, expect } = require("chai");
const stealthTransfer = require("../../input/stealthTransfer.json");

describe("Find Stealth Recipient (Part 3)", function() {

  describe("Public Test 1", function() {

    // Private key: 0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef
    // Secret: 0x12341234
    it("Should have the private key to recipient address", async function() {

      let stealthRecipient;
      try {
        stealthRecipient = require("../../output/stealthRecipient.json");
      } catch {
        assert(false, "Failed to open output/stealthRecipient.json");
      }

      const wallet = new ethers.Wallet(stealthRecipient.privateKey);
      expect(wallet.address).to.equal(stealthTransfer.stealthRecipient);

    });
    
  });

});
