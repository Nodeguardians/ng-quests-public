// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestMemoryLayout.sol";

contract PublicTest1 is TestMemoryLayout {
    string PATH = "test/data/memoryLayout.json";
    string KEY = "[0]";
    constructor() TestMemoryLayout(PATH, KEY) { } 
}

contract PublicTest2 is TestMemoryLayout {
    string PATH = "test/data/memoryLayout.json";
    string KEY = "[1]";
    constructor() TestMemoryLayout(PATH, KEY) { } 
}
