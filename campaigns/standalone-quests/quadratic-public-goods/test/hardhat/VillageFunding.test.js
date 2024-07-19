const { testVillageFunding } = require("./testsuites/TestVillageFunding.js");

describe("Village Funding (Part 2)", function() {
  const inputs1 = require("../../test/data/VillageFunding1.json");
  testVillageFunding("Public Test 1", inputs1);

  const inputs2 = require("../../test/data/VillageFunding2.json");
  testVillageFunding("Public Test 2", inputs2);
});