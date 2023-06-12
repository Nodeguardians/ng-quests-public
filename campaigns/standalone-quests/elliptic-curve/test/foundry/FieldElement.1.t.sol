// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestFieldElement.sol";

contract PublicTest1 is TestFelt {
    string PATH = "test/data/feltOperations.json";
    string KEY = "[0]";
    constructor() TestFelt(PATH, KEY) { }
}

contract PublicTest2 is TestFelt {
    string PATH = "test/data/feltOperations.json";
    string KEY = "[1]";
    constructor() TestFelt(PATH, KEY) { }
}
