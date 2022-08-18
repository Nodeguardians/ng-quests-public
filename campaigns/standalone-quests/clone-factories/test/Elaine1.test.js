const { ethers } = require("hardhat");
const { testElaine } = require("./testsuites/testElaine");

inputs = [
  {
    name: "Public Test 1",
    amount: ethers.utils.parseEther("1"),
    duration: 10000000,
    divisions: 4
  }
]

describe("Elaine (Part 1)", function () {
  inputs.forEach(testElaine);
});