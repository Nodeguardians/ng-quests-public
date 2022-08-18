const { ethers } = require("hardhat");
const { testFreeMemoryPointer } = require("./testsuites/testFreeMemoryPointer");

input = {
  name: "Public Test 1",
  freeMemoryPointer: ["0x80", "0x120"],
  maxAccessedMemory: ["0x80", "0x100"],
  allocateMemory: ["0x20", "0x100"],
  freeMemory: [["0x20", "0x20"], ["0x20", "0x21"]]
}

describe("Free Memory Pointer (Part 1)", function() {
  testFreeMemoryPointer(input);
});
