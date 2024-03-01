const { testAmuletCreation } = require("./testsuites/testAmuletCreation");
const input = require("../data/amuletCreation.json");

describe("Amulet Creation (Part 2)", function() {
  testAmuletCreation("Public Test 1", input[0]);
});