const { testMasks } = require("./testsuites/testMasks");
const inputs = require("../data/masks.json");

describe("Masks (Part 2)", function() {
  testMasks("Public Test 1", inputs[0]);
  testMasks("Public Test 2", inputs[1]);
});
