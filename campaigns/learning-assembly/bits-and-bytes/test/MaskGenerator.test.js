const { ethers } = require("hardhat");
const { testMaskGenerator } = require("./testsuites/testMaskGenerator");

inputs = [
  {
    name: "Public Test 1",
    nBytes: 2,
    at: 0,
    reversed: false
  },
  {
    name: "Public Test 2",
    nBytes: 17,
    at: 3,
    reversed: false
  },
  {
    name: "Public Test 3",
    nBytes: 20,
    at: 13,
    reversed: false
  }
]

describe("Mask Generator (Part 3)", function() {
  inputs.forEach(testMaskGenerator)
});
