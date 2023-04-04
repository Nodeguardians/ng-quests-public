const { testIf } = require("./testsuites/testIf");
const inputs = require("../data/if.json");

describe("If (Part 4)", function() {
  testIf("Public Test 1", inputs[0]);
  testIf("Public Test 2", inputs[1]);
});
