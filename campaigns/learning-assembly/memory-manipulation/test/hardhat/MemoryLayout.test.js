const { testMemoryLayout } = require("./testsuites/testMemoryLayout");
const inputs = require("../data/memoryLayout.json");

describe("Memory Layout (Part 3)", function() {
  testMemoryLayout("Public Test 1", inputs[0]);
  testMemoryLayout("Public Test 2", inputs[1]);
});
