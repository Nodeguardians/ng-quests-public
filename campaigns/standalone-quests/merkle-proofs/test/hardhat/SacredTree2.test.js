const { testTree } = require("./testsuites/testTree");
const proofTests = require("../data/proofs.json");


describe("Sacred Tree (Part 2)", function() {
  testTree("Public Test 1", proofTests[0]);
  testTree("Public Test 2", proofTests[1]);
});