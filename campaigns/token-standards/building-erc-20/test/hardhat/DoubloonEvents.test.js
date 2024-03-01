const { testDoubloonEvents } = require("./testsuites/testDoubloonEvents");
const input = require("../data/doubloonTransfer.json");

describe("Doubloon Events (Part 4)", function() {
  testDoubloonEvents("Public Test 1", input[0]);
  testDoubloonEvents("Public Test 2", input[1]);
});