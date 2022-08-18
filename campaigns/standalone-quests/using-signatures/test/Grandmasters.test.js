const { ethers } = require("hardhat");
const { parseEther } = require("ethers/lib/utils");
const { testGrandmasters } = require("./testsuites/testGrandmasters");

inputs = [
  {
    name: "Public Test 1",
    creator: ethers.getSigner(0),
    recipient: ethers.getSigner(1),
    other: ethers.getSigner(2),
    amount: parseEther("100")
  },
  {
    name: "Public Test 2",
    creator: ethers.getSigner(1),
    recipient: ethers.getSigner(2),
    other: ethers.getSigner(0),
    amount: parseEther("0.25")
  }
]

describe("Grandmasters (Part 2)", function() {
  inputs.forEach(testGrandmasters)
});