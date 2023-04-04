const { testFor } = require("./testsuites/testFor");
const inputs = require("../data/for.json");

describe("For (Part 6)", function() {
  testFor("Public Test 1", inputs[0]);
  testFor("Public Test 2", inputs[1]);
});
