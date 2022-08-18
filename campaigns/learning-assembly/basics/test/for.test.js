const { testFor } = require("./testsuites/testFor");

inputs = [
  { name: "Private Test 1", beg: 4, end: 37 },
  { name: "Private Test 2", beg: 11, end: 11 },
]

describe("For (Part 5)", function() {
  inputs.forEach(testFor)
});
