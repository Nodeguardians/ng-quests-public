const inputs = require("../data/inputs.json");
const { testChallenge, testMeasureChallenge } = require("./testsuites/testChallenge");
const { cheating } = require("@node-guardians/ng-quests-helpers");

describe("Challenge (Part 1)", function () {
  // Correctness tests
  for (let i = 0; i < inputs.length; i++) {
    testChallenge(`Public Test ${i + 1}`, inputs[i], false);
  }

  // Gas efficiency test
  testMeasureChallenge(inputs, 60000);

  // External code test
  cheating.testExternalCode("contracts/Challenge.sol");
});
