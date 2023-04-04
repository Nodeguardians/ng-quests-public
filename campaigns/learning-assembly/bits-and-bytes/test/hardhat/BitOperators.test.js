const { testBitOperators } = require("./testsuites/testBitOperators");
const inputs = require("../data/bitOperators.json");

describe("Bit Operators (Part 1)", function() {
  testBitOperators("Public Test 1", inputs[0]);
  testBitOperators("Public Test 2", inputs[1]);
});
