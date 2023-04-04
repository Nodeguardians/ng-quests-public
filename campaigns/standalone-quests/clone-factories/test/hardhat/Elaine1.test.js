const { testElaine } = require("./testsuites/testElaine");
const catData = require("../data/catData.json");

describe("Elaine (Part 1)", function () {
  testElaine("Public Test 1", catData);
});