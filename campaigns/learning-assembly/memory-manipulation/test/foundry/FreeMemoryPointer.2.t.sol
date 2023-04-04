// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestFreeMemoryPointer.sol";

contract PublicTest1 is TestFreeMemoryPointer {
    string PATH = "test/data/freeMemoryPointer.json";
    constructor() TestFreeMemoryPointer(PATH) { } 
}
