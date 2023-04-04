const { testGreatScribe } = require("./testsuites/testGreatScribe.js");
const input = require("../data/greatScribe.json");

describe("GreatScribe (Part 1)", function() {
  input.callee = "GreatArchives";
  testGreatScribe("Public Test 1", input);
});
