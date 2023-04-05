const { testFeltArithmetic } = require("./testsuites/testFieldElement.js");
const inputs = require("../data/feltOperations.json"); 

describe("Field Element (Part 1)", function() {
  testFeltArithmetic("Public Test 1", inputs[0]);
  testFeltArithmetic("Public Test 2", inputs[1]);
});