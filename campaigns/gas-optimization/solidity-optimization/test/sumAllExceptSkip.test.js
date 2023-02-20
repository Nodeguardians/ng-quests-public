const { cheating } = require("@ngquests/test-helpers");
const { testCopyArray } = require("./testsuites/testSumAllExceptSkip");
const GasProfiler = require("./gasReporter.js");
const { ethers } = require("hardhat");

inputs = [
  {
    name: "Public Test 1",
    array: [1, 2, 3],
    skip: 0,
    target: 2550,
  },
  {
    name: "Public Test 2",
    array: [1, 2, 3, 3, 4, 5, 6, 7],
    skip: 3,
    target: 4550,
  },
  {
    name: "Public Test 3",
    array: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 11],
    skip: 11,
    target: 7050,
  },
  {
    name: "Public Test 4",
    array: [ethers.constants.MaxUint256, 1],
    skip: 2,
    target: 0,
  },
];

describe("SumAllExceptSkip (Part 1)", function () {
  const gasConsumed = [];

  for (const input of inputs) {
    testCopyArray(input, gasConsumed);
  }

  cheating.testExternalCode("contracts/Challenge.sol");

  after(function () {
    GasProfiler.logTable(gasConsumed, { padding: 4 });
  });
});
