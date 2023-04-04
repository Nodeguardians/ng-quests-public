const { keccak256, toUtf8Bytes } = require("ethers/lib/utils.js");
const { expect, assert } = require("chai");

function testForTreasure(index, expectedHash) {

  describe("Public Test 1", function () {
    it("Treasure found", async function() {

      let treasure;
      try {
        treasure = require("../../output/treasure.json");
      } catch {
        assert(false, "Failed to open output/treasure.json");
      }

      assert(treasure.length > index, "No treasure found");
      expect(keccak256(toUtf8Bytes(treasure[index])))
        .to.equal(expectedHash);

    }); 
  });

}

describe("Rock Quarry (Part 1)", function () {

  testForTreasure(0, "0x18d7f451b112d9d66d372b57a0f006069ccc3e6f27848af53713260f77ed03c2");

});

describe("Emerald Quarry (Part 2)", function () {

  testForTreasure(1, "0xf10ae9bec86eee2391ad0cfed71a6ab8bd63c437cfe4a1a65cc27dc482c8640f");

});

describe("Ruby Quarry (Part 3)", function () {

  testForTreasure(2, "0x37624ea007df73dcf742c012ecd6b45423a79e118153e712c2b51ed33779dcff");

});