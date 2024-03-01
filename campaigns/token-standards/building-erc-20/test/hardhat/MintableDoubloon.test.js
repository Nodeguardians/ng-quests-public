const { testMintableDoubloon } = require("./testsuites/testMintableDoubloon");
const input = require("../data/mintableDoubloon.json");

describe("Mintable Doubloon (Part 5)", function() {
  testMintableDoubloon("Public Test 1", input[0]);
  testMintableDoubloon("Public Test 2", input[1]);
});