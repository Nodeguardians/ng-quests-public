// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestMasks.sol";

contract PublicTest1 is TestMasks {
    string PATH = "test/data/masks.json";
    string KEY = "[0]";
    constructor() TestMasks(PATH, KEY) { } 
}

contract PublicTest2 is TestMasks {
    string PATH = "test/data/masks.json";
    string KEY = "[1]";
    constructor() TestMasks(PATH, KEY) { } 
}
