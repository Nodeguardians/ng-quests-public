const { testCrates } = require("./testsuite/testCrates2");
const crateData = require("../data/crates.json");


describe("Crates (Part 2)", function() {
  testCrates("Public Test 1", crateData)
});