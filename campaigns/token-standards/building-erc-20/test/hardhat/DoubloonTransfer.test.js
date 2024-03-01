const { testDoubloonTransfer } = require("./testsuites/testDoubloonTransfer");
const input = require("../data/doubloonTransfer.json");

describe("Doubloon Transfer (Part 3)", function() {
  testDoubloonTransfer("Public Test 1", input[0]);
  testDoubloonTransfer("Public Test 2", input[1]);
});