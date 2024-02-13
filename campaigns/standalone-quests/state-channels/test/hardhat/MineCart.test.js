const { testMineCart } = require("./testsuites/testMineCart");
const inputs = require("../data/mineCart.json");

describe("Mine Cart (Part 2)", function() {
  testMineCart("Public Test 1", inputs[0]);
  testMineCart("Public Test 2", inputs[1]);
});
