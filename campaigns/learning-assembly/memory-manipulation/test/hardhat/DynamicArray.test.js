const { testDynamicArray } = require("./testsuites/testDynamicArray");
const inputs = require("../data/dynamicArray.json");

describe("Dynamic Array (Part 4)", function() {
  testDynamicArray("Public Test 1", inputs[0]);
  testDynamicArray("Public Test 2", inputs[1]);
});
