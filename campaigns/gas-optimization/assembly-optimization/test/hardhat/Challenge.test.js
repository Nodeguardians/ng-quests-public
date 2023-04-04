const { testCopyArray } = require("./testsuites/testChallenge.js");
const GasReporter = require("./gasReporter.js");
const inputs = require("../data/arrays.json");

describe("Challenge (Part 1)", function() {

  const gasConsumed = [];

  testCopyArray("Public Test 1", inputs[0], gasConsumed);
  testCopyArray("Public Test 2", inputs[1], gasConsumed);
  testCopyArray("Public Test 3", inputs[2], gasConsumed);

  after(function () {
    GasReporter.logTable(gasConsumed, {padding: 4});
  });
  
});
