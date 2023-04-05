const { testCurveOperations } = require("./testsuites/testEllipticCurve.js");
const inputs = require("../data/curveOperations.json");

describe("EllipticCurve (Part 2)", function() {
  testCurveOperations("Public Test 1", inputs[0]);
  testCurveOperations("Public Test 2", inputs[1]);
});