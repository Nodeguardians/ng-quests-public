const { testScrambled } = require("./testsuites/testScrambled");
const inputs = require("../data/scrambled.json");

describe("Scrambled (Part 4)", function() {
  testScrambled("Public Test 1", inputs[0]);
  testScrambled("Public Test 2", inputs[1]);
});
