// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestBitOperators.sol";

contract PublicTest1 is TestBitOperators {
    string PATH = "test/data/bitOperators.json";
    string KEY = "[0]";
    constructor() TestBitOperators(PATH, KEY) { } 
}

contract PublicTest2 is TestBitOperators {
    string PATH = "test/data/bitOperators.json";
    string KEY = "[1]";
    constructor() TestBitOperators(PATH, KEY) { } 
}