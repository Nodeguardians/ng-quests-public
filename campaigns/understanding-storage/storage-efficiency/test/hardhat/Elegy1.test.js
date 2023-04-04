const { testElegy1 } = require("./testsuites/testElegy1");
const input = require("../data/verses.json");

describe("Elegy1 (Part 1)", function() {
  testElegy1("Public Test 1", input);
});