const { testPaymentChannel } = require("./testsuites/testPaymentChannel");
const inputs = require("../data/paymentChannel.json");

describe("Payment Channel (Part 1)", function() {
  testPaymentChannel("Public Test 1", inputs[0]);
  testPaymentChannel("Public Test 2", inputs[1]);
  testPaymentChannel("Public Test 3", inputs[2]);
});
