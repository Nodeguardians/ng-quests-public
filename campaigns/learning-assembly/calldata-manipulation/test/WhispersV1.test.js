const { ethers } = require("hardhat");
const { testWhispersV1 } = require("./testsuites/testWhispersV1");

input = {
  name: "Public Test 1",
  uintValues: [128, 256, ethers.constants.MaxUint256],
  strValues: [
    "test string",
    "UTF-8 𝄞 test string",
    "A very very very very very very very very very very very very very very very very very long test string"
  ]
}

describe("WhispersV1 (Part 2)", function() {
  testWhispersV1(input);
});
