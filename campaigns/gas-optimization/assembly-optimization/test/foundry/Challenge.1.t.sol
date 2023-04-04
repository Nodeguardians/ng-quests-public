// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestChallenge.sol";

contract PublicTest1 is TestCopyArray {
    string PATH = "test/data/arrays.json";
    string KEY = "[0]";
    constructor() TestCopyArray(PATH, KEY) { }
}

contract PublicTest2 is TestCopyArray {
    string PATH = "test/data/arrays.json";
    string KEY = "[1]";
    constructor() TestCopyArray(PATH, KEY) { }
}

contract PublicTest3 is TestCopyArray {
    string PATH = "test/data/arrays.json";
    string KEY = "[2]";
    constructor() TestCopyArray(PATH, KEY) { }
}