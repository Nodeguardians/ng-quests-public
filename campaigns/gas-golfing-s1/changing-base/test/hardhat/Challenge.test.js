const inputs = require("../data/inputs.json");
const moreInputs = require("../data/moreInputs.json");
const { testChallenge, testMeasureChallenge } = require("./testsuites/testChallenge");
const { cheating } = require("@node-guardians/ng-quests-helpers");

describe("Challenge (Part 1)", function () {

  // Correctness Tests
  describe("Public Test 1", function () {
    testChallenge([inputs[0], inputs[1]], false);
  });

  describe("Public Test 2", function () {
    testChallenge([inputs[2], inputs[3]], false);
  });

  describe("Public Test 3", function () {
    testChallenge([inputs[4], inputs[5]], false);
  });

  describe("Public Test 4", function () {
    testChallenge(moreInputs, false);
  });

  // Gas Efficiency Test
  testMeasureChallenge(moreInputs, 50000);

  // External Code Test
  cheating.testGolfingConstraints("contracts/Challenge.sol");

});
