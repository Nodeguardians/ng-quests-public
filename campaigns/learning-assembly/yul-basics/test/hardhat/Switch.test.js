const { testSwitch } = require("./testsuites/testSwitch");
const inputs = require("../data/switch.json");

describe("Switch (Part 5)", function() {
  testSwitch("Public Test 1", inputs[0]);
  testSwitch("Public Test 2", inputs[1]);
});
