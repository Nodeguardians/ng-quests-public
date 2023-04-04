const { testCrates } = require("./testsuite/testCrates1");
const crateData = require("../data/crates.json");

describe("Crates (Part 1)", function() {
  testCrates("Public Test 1", crateData)
});