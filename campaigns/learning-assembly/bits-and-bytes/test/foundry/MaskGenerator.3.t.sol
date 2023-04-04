// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestMaskGenerator.sol";

contract PublicTest1 is TestMaskGenerator {
    string PATH = "test/data/maskGenerator.json";
    string KEY = "[0]";
    constructor() TestMaskGenerator(PATH, KEY) { } 
}

contract PublicTest2 is TestMaskGenerator {
    string PATH = "test/data/maskGenerator.json";
    string KEY = "[1]";
    constructor() TestMaskGenerator(PATH, KEY) { } 
}

contract PublicTest3 is TestMaskGenerator {
    string PATH = "test/data/maskGenerator.json";
    string KEY = "[2]";
    constructor() TestMaskGenerator(PATH, KEY) { } 
}
