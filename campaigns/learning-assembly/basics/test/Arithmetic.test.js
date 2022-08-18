const { ethers } = require("hardhat");
const { testArithmetic } = require("./testsuites/testArithmetic");

inputs = [
  {
    name: "Public Test 1",
    addition: [2, 1],
    multiplication: [1, -1],
    signedDivision: [-1, 1],
    modulo: [ethers.constants.MaxUint256, 2],
    power: [1, 0]
  }
]

describe("Arithmetic (Part 1)", function() {
  inputs.forEach(testArithmetic)
});
