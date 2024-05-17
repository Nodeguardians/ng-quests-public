const { testPaymaster } = require("./testsuites/TestPaymaster.js");

describe("Lunar Paymaster (Part 2)", function() {
    const inputs = require("./data/inputs.json");
    testPaymaster('Public Test 1', inputs[0]);
    testPaymaster('Private Test 2', inputs[1]);
});