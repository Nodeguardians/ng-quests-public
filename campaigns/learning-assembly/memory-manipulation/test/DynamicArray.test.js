const { testDynamicArray } = require("./testsuites/testDynamicArray");

inputs = [
  {
    name: "Public Test 1",
    push: [[1, 2, 3], 4],
    pop: [1, 5, 2],
    popAt: [[1, 5, 2, 1], 1]
  },
  {
    name: "Public Test 2",
    push: [[], 1],
    pop: [],
    popAt: [[1, 2, 3], 3]
  }
]

describe("Dynamic Array (Part 3)", function() {
  inputs.forEach(testDynamicArray)
});
