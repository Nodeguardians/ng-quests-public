const { testComparisons } = require("./testsuites/testComparisons");
const input = require("../data/comparisons.json");

describe("Comparisons (Part 3)", function() {
  testComparisons("Public Test 1", input);
});
