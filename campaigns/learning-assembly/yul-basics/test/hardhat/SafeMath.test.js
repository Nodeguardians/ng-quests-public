const { testSafeMath } = require("./testsuites/testSafeMath");
const inputs = require("../data/safemath.json");

describe("SafeMath (Part 7)", function() {
  testSafeMath("Public Test 1", inputs[0]);
  testSafeMath("Public Test 2", inputs[1]);
});
