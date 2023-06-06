const { testCall } = require("./testsuites/TestCall.js");
const { testStaticCall } = require("./testsuites/TestStaticCall.js");

describe("Call & Staticcall (Part 5)", function () {
  describe("Call", function () {
    testCall("Public Test 1");
  });

  describe("Staticcall", function () {
    testStaticCall("Public Test 1");
  });
});
