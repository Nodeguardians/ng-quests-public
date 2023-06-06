const { testCreate } = require("./testsuites/TestCreate.js");
const { testCreate2 } = require("./testsuites/TestCreate2.js");

describe("Create (Part 7)", function () {
  describe("Create", function () {
    testCreate("Public Test 1");
  });

  describe("Create2", function () {
    testCreate2("Public Test 1");
  });
});
