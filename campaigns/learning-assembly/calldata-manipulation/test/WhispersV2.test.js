const { ethers } = require("hardhat");
const { testWhispersV2 } = require("./testsuites/testWhispersV2");

inputs = [
  {
    name: "Public Test 1",
    values: [1, 193, 347, 502, 999, 1976, 2073, ethers.constants.MaxUint256]
  },
  {
    name: "Public Test 2",
    values: [1, 0, 0, 0, ethers.constants.MaxUint256, 0, 1]
  },
  {
    name: "Public Test 3",
    values: []
  }
];

describe("WhispersV2 (Part 2)", function () {
  inputs.forEach(testWhispersV2);
});
