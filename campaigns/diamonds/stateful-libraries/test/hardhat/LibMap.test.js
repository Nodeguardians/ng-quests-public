const { testLibMap } = require("./testsuites/testLibMap");
const input = require("../data/paths.json");

describe('LibMap (Part 1)', async function () {
  testLibMap("Public Test 1", input);
});