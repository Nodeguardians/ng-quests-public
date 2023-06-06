const { testCallCode } = require("./testsuites/TestCallCode.js");
const { testDelegateCall } = require("./testsuites/TestDelegateCall.js");

describe("DelegateCall & CallCode (Part 6)", function () {
  describe("DelegateCall", function () {
    testDelegateCall("Public Test 1");
  });

  describe("CallCode", function () {
    testCallCode("Public Test 1");
  });
});
