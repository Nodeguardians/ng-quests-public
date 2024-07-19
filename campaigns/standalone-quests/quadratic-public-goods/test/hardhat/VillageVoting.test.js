const { testVillageVoting } = require("./testsuites/TestVillageVoting.js");

describe("Village Voting (Part 1)", function() {
  const inputs1 = require("../../test/data/VillageVoting1.json");
  testVillageVoting("Public Test 1", inputs1);

  const inputs2 = require("../../test/data/VillageVoting2.json");
  testVillageVoting("Public Test 2", inputs2);
});