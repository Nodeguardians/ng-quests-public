const { testElegy2 } = require("./testsuites/testElegy2");

inputs = [
  {
    name: "Public Test 1",
    initArray: [
      25021323, 62912, 98122, 1231, 4088, 7873, 239, 191, 3941, 12, 91240, 1234901, 12390121, 1234101, 1412, 39013241
    ],
    nonce: 3,
    gasLimit: 75000
  },
  {
    name: "Public Test 2",
    initArray: [
      85831, 391, 8120, 1231, 4081, 7673, 101010, 191, 3293211, 121, 13401, 3213, 4921, 11
    ],
    nonce: 5,
    gasLimit: 70000
  }
]

describe("Elegy2 (Part 2)", function() {
  inputs.forEach(testElegy2);
});