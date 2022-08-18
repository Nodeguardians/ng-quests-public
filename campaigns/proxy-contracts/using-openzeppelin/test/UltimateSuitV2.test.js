const { ethers } = require("hardhat");

const { testSuit } = require("./testsuites/testSuitV2.js");

inputs = [
  {
    name: "Public Test 1",
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
  },
  {
    name: "Public Test 2",
    threshold: ethers.utils.parseEther("1"),
    steps: [
      { action: "getTotalEnergy", expectedValue: 0 },
      { action: "offer", src: 0, value: ethers.utils.parseEther("0.5") },
      { action: "offer", src: 1, value: ethers.utils.parseEther("0.5") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1") },
      { action: "getEnergy", src: 0, expectedValue: ethers.utils.parseEther("0.5") },
      { action: "getEnergy", src: 1, expectedValue: ethers.utils.parseEther("0.5") },
      { action: "fireLaser", reverted: true },
      { action: "offer", src: 0, value: ethers.utils.parseEther("0.5") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1.5") },
      { action: "getEnergy", src: 0, expectedValue: ethers.utils.parseEther("1") },
      { action: "fireLaser", reverted: false },
      { action: "getTotalEnergy", expectedValue: 0 },
      { action: "getEnergy", src: 0, expectedValue: 0 },
      { action: "offer", src: 1, value: ethers.utils.parseEther("0.5") },
      { action: "getEnergy", src: 1, expectedValue: ethers.utils.parseEther("0.5") }
    ]   
  },
  {
    name: "Public Test 3",
    threshold: ethers.utils.parseEther("2"),
    steps: [
      { action: "getTotalEnergy", expectedValue: 0 },
      { action: "offer", src: 0, value: ethers.utils.parseEther("2") },
      { action: "offer", src: 1, value: ethers.utils.parseEther("1") },
      { action: "withdraw", src: 0, expectedValue: ethers.utils.parseEther("2") },
      { action: "getEnergy", src: 0, expectedValue: 0 },
      { action: "getEnergy", src: 1, expectedValue: ethers.utils.parseEther("1") },
      { action: "fireLaser", reverted: true },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1") },
      { action: "offer", src: 0, value: ethers.utils.parseEther("1") },
      { action: "getEnergy", src: 0, expectedValue: ethers.utils.parseEther("1") },
      { action: "withdraw", src: 0, expectedValue: ethers.utils.parseEther("1") },
      { action: "getTotalEnergy", expectedValue: ethers.utils.parseEther("1") },
      { action: "offer", src: 1, value: ethers.utils.parseEther("2") },
      { action: "fireLaser", reverted: false },
      { action: "withdraw", src: 0, expectedValue: 0 }
    ]   
  }
]

describe("UltimateSuitV2 (Part 2)", function() {
  inputs.forEach(testSuit);
});

