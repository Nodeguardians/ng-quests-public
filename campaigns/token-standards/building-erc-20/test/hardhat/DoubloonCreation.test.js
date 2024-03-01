const { testDoubloonCreation } = require("./testsuites/testDoubloonCreation");
const input = require("../data/doubloonCreation.json");

describe("Doubloon Creation (Part 2)", function() {
  testDoubloonCreation("Public Test 1", input[0]);
  testDoubloonCreation("Public Test 2", input[1]);
});