const { testMaskGenerator } = require("./testsuites/testMaskGenerator");
const inputs = require("../data/maskGenerator.json");

describe("Mask Generator (Part 3)", function() {
  testMaskGenerator("Public Test 1", inputs[0]);
  testMaskGenerator("Public Test 2", inputs[1]);
  testMaskGenerator("Public Test 3", inputs[2]);
});
