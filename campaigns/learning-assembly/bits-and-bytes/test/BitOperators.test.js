const { ethers } = require("hardhat");
const { testBitOperators } = require("./testsuites/testBitOperators");

inputs = [
  {
    name: "Public Test 1",
    shiftLeft: [3, 5],
    setBit: [4500779, 196],
    clearBit: [ethers.constants.MaxUint256, 254],
    flipBit: [0, 17],
    getBit: [8, 3]
  },
  {
    name: "Public Test 2",
    shiftLeft: [ethers.constants.MaxUint256, 256],
    setBit: [3, 0],
    clearBit: [0, 128],
    flipBit: [3, 1],
    getBit: [2002, 0]
  }
];

describe("Bit Operators (Part 1)", function() {
  inputs.forEach(testBitOperators)
});
