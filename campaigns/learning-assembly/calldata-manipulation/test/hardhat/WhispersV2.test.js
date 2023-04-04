const { cheating } = require("@ngquests/test-helpers");
const { testWhispersV2 } = require("./testsuites/testWhispersV2");
const inputs = require("../data/whispersV2.json");

describe("WhispersV2 (Part 3)", function () {
  testWhispersV2("Public Test 1", inputs[0]);
  testWhispersV2("Public Test 2", inputs[1]);
  testWhispersV2("Public Test 3", {compressed: "0x", uncompressed: []});
});
