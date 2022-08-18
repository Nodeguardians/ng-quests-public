const { ethers } = require("hardhat");

const { testSuit } = require("./testsuites/testSuitV1.js");

inputs = [
  {
    name: "Public Test 1",
    threshold: ethers.utils.parseEther("1"),
    steps: [
      { action: "getTotalEnergy", expectedValue: 0 },
      { action: "offer", src: 0, value: ethers.utils.parseEther("0.5") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("0.5") },
      { action: "getEnergy", src: 0, expectedValue: ethers.utils.parseEther("0.5") },
      { action: "getEnergy", src: 1, expectedValue: ethers.utils.parseEther("0") },
      { action: "fireLaser", reverted: true },
      { action: "offer", src: 0, value: ethers.utils.parseEther("1") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1.5") },
      { action: "fireLaser", reverted: false }
    ]
  },
  {
    name: "Public Test 2",
    threshold: ethers.utils.parseEther("1.5"),
    steps: [
      { action: "getTotalEnergy", expectedValue: 0 },
      { action: "offer", src: 0, value: ethers.utils.parseEther("0.5") },
      { action: "offer", src: 1, value: ethers.utils.parseEther("0.5") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1") },
      { action: "getEnergy", src: 0, expectedValue: ethers.utils.parseEther("0.5") },
      { action: "getEnergy", src: 1, expectedValue: ethers.utils.parseEther("0.5") },
      { action: "fireLaser", reverted: true },
      { action: "offer", src: 0, value: ethers.utils.parseEther("0.5") },
      { action: "offer", src: 2, value: ethers.utils.parseEther("0.25") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1.75") },
      { action: "getEnergy", src: 0, expectedValue: ethers.utils.parseEther("1") },
      { action: "getEnergy", src: 2, expectedValue: ethers.utils.parseEther("0.25") },
      { action: "fireLaser", reverted: false }
    ]   
  }
]

describe("UltimteSuitV1 (Part 1)", function() {
  inputs.forEach(testSuit);
});

