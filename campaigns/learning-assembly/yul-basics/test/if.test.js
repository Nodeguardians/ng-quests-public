const { ethers } = require("hardhat");
const { testIf } = require("./testsuites/testIf");

inputs = [
  {
    name: "Public Test 1",
    minutes: ethers.BigNumber.from(60)
  },
  {
    name: "Public Test 2",
    minutes: ethers.BigNumber.from(-1)
  }
]

describe("If (Part 3)", function() {
  inputs.forEach(testIf)
});
