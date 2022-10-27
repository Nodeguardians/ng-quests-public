const { cheating } = require("@ngquests/test-helpers");
const { ethers } = require("hardhat");
const { testMasks } = require("./testsuites/testMasks");

inputs = [
  {
    name: "Public Test 1",
    setMask: [ethers.BigNumber.from("0x1F00FF00FF00FF00"), ethers.BigNumber.from('0xFFFFFF00FF00FF')],
    clearMask: [ethers.BigNumber.from("0xFFFFFF00FF00FF00"), ethers.BigNumber.from("0xFF00FF00FF00FF00")],
    get8BytesAt: [ethers.BigNumber.from("0x12341234"), 0]
  },
  {
    name: "Public Test 2",
    setMask: [ethers.BigNumber.from("0x001F1F1F1F"), ethers.BigNumber.from('0xFFFF0000')],
    clearMask: [ethers.BigNumber.from("0x0000FFFFF"), ethers.BigNumber.from("0x00001F1F")],
    get8BytesAt: [ethers.BigNumber.from("0x1234ABCDABCDABCDABCD12341234"), 2]
  }
]

describe("Masks (Part 2)", function() {
  inputs.forEach(testMasks);

  cheating.testAssemblyAll("contracts/MaskGenerator.sol");
  cheating.testExternalCode("contracts/MaskGenerator.sol");
});
