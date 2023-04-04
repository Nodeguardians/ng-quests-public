const { testCursedGrimoires } = require("./testsuites/testCursedGrimoires");
const inputs = require("../data/cursedGrimoires.json");

describe("Cursed Grimoires (Part 2)", function() {

  testCursedGrimoires("Public Test 1", inputs[0]);
  testCursedGrimoires("Public Test 2", inputs[1]);

});