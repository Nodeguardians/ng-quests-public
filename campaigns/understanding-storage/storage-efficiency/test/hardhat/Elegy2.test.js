const { testElegy2 } = require("./testsuites/testElegy2");
const inputs = require("../data/songs.json");

describe("Elegy2 (Part 2)", function() {
  testElegy2("Public Test 1", inputs[0]);
  testElegy2("Public Test 2", inputs[1]);
});