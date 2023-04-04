const { testArithmetic } = require("./testsuites/testArithmetic");
const inputs = require("../data/arithmetic.json");

describe("Arithmetic (Part 2)", function() {
  testArithmetic("Public Test 1", inputs[0]);
});
