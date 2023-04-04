const { testFreeMemoryPointer } = require("./testsuites/testFreeMemoryPointer");
const input = require("../data/freeMemoryPointer.json");

describe("Free Memory Pointer (Part 2)", function() {
  testFreeMemoryPointer("Public Test 1", input);
});
