// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestDoubloonCreation.sol";

contract PublicTest1 is TestDoubloonCreation {
    string DATA_PATH = "test/data/doubloonCreation.json";
    string DATA_KEY = "[0]";
    constructor() TestDoubloonCreation(DATA_PATH, DATA_KEY) { }
}

contract PublicTest2 is TestDoubloonCreation {
    string DATA_PATH = "test/data/doubloonCreation.json";
    string DATA_KEY = "[1]";
    constructor() TestDoubloonCreation(DATA_PATH, DATA_KEY) { }
}