const { 
  testSumAllExceptSkip, 
  testOverflow 
} = require("./testsuites/TestChallenge.js");
const GasProfiler = require("./gasReporter.js");
const inputs = require("../data/arrays.json");

describe("Challenge (Part 1)", function () {
  const gasConsumed = [];
  
  testSumAllExceptSkip("Public Test 1", inputs.efficiencyTests[0], gasConsumed);
  testSumAllExceptSkip("Public Test 2", inputs.efficiencyTests[1], gasConsumed);
  testSumAllExceptSkip("Public Test 3", inputs.efficiencyTests[2], gasConsumed);

  testOverflow("Public Test 4", inputs.overflowTests[0]);

  after(function () {
    GasProfiler.logTable(gasConsumed, { padding: 4 });
  });

});
