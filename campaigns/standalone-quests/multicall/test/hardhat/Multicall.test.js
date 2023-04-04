const { testMulticall } = require("./testsuites/testMulticall.js");
const input = require("../data/multicall.json");

describe("Multicall (Part 2)", function() {
  input.callee = "GreaterArchives";
  testMulticall("Public Test 1", input);
});
