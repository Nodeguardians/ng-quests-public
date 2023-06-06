const { testInstructions } = require("./testsuites/TestInstructions.js");
const inputs = require("../data/instructions.json");

describe("Instructions (Part 4)", function () {
  for (let i = 0; i < inputs.length; i++) {
    testInstructions(`Public Test ${i + 1}`, inputs[i]);
  }
});
