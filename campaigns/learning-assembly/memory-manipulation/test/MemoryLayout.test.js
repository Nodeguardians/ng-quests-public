const { cheating } = require("@ngquests/test-helpers");
const { ethers } = require("hardhat");
const { testMemoryLayout } = require("./testsuites/testMemoryLayout");

inputs = [
  {
    name: "Public Test 1",
    createUint256Array: [ethers.constants.Zero, ethers.constants.Zero],
    createBytesArray: [ethers.constants.Zero, ethers.constants.Zero]
  },
  {
    name: "Public Test 2",
    createUint256Array: [ethers.constants.Zero, ethers.constants.MaxUint256],
    createBytesArray: [ethers.constants.Zero, ethers.BigNumber.from("0xFF")]
  }
]

describe("Memory Layout (Part 3)", function() {
  inputs.forEach(testMemoryLayout);

  cheating.testAssemblyAll("contracts/MemoryLayout.sol");
  cheating.testExternalCode("contracts/MemoryLayout.sol");
});
