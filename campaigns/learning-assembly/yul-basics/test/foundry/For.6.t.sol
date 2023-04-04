// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestFor.sol";

contract PublicTest1 is TestFor {
    string PATH = "test/data/for.json";
    string KEY = "[0]";
    constructor() TestFor(PATH, KEY) { } 
}

contract PublicTest2 is TestFor {
    string PATH = "test/data/for.json";
    string KEY = "[1]";
    constructor() TestFor(PATH, KEY) { } 
}
