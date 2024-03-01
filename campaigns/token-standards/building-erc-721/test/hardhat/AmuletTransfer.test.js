const { 
  testAmuletTransfer, 
  testAmuletSafeTransfer, 
  testAmuletEvents
} = require("./testsuites/testAmuletTransfer");
const input = require("../data/amuletTransfer.json");

describe("Amulet Transfer (Part 3)", function() {
  testAmuletTransfer("Public Test 1", input[0]);
  testAmuletSafeTransfer("Public Test 2", input[0]);
  testAmuletEvents("Public Test 3");
});