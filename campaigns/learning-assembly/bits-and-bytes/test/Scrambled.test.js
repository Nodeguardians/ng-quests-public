const { testScrambled } = require("./testsuites/testScrambled");

inputs = [
  {
    name: "Public Test 1",
    address: "0x8b649939bce3F0B3E0a1358485DcF5C1A19135E6"
  },
  {
    name: "Public Test 2",
    address: "0xAb4fE3085C011874440B1439945069AB65Ef0a38"
  }
]

describe("Scrambled (Part 4)", function() {
  inputs.forEach(testScrambled)
});
