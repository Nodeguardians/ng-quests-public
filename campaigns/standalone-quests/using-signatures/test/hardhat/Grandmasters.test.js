const { 
  testGrandmasters, 
  testInitialGrandmaster 
} = require("./testsuites/testGrandmasters");
const sigData = require("../data/signatures.json");

describe("Grandmasters (Part 2)", function() {

  describe("Public Test 1", function () {
    testInitialGrandmaster();
  });

  describe("Public Test 2", function () {
    testGrandmasters(sigData);
  });

});
