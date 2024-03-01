const { testAmuletPouch } = require("./testsuites/testAmuletPouch");
const input = require("../data/amuletPouch.json");

describe("Amulet Pouch (Part 4)", function() {
  testAmuletPouch("Public Test 1", input[0]);
});