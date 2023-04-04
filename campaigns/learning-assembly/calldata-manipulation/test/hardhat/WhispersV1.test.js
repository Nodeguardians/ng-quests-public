const { testWhispersV1 } = require("./testsuites/testWhispersV1");
const input = require("../data/WhispersV1.json");

describe("WhispersV1 (Part 2)", function() {
  testWhispersV1("Public Test 1", input);
});
