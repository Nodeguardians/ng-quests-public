// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestScrambled.sol";

contract PublicTest1 is TestScrambled {
    string PATH = "test/data/scrambled.json";
    string KEY = "[0]";
    constructor() TestScrambled(PATH, KEY) { } 
}

contract PublicTest2 is TestScrambled {
    string PATH = "test/data/scrambled.json";
    string KEY = "[1]";
    constructor() TestScrambled(PATH, KEY) { } 
}
