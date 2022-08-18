const { Action, testLibMap } = require("./testsuite/testLibMap");

input = {
  name: "Public Test 1",
  steps: [
    { action: Action.Travel, to: "island A", expected: false },
    { action: Action.AddPath, from: "harbor", to: "island A"},
    { action: Action.Travel, to: "island A", expected: true },
    { action: Action.Travel, to: "harbor", expected: false },
    { action: Action.AddPath, from: "island A", to: "island B"},
    { action: Action.AddPath, from: "island B", to: "island C"},
    { action: Action.Travel, to: "island C", expected: false },
    { action: Action.Travel, to: "island B", expected: true },
    { action: Action.Travel, to: "island C", expected: true }
  ],
  slots: 5000
}

describe('LibMap (Part 1)', async function () {
  testLibMap(input);
});