// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestDoubloonEvents.sol";

contract PublicTest1 is TestDoubloonEvents {
    string DATA_PATH = "test/data/doubloonTransfer.json";
    string DATA_KEY = "[0]";
    constructor() TestDoubloonEvents(DATA_PATH, DATA_KEY) { }
}

contract PublicTest2 is TestDoubloonEvents {
    string DATA_PATH = "test/data/doubloonTransfer.json";
    string DATA_KEY = "[1]";
    constructor() TestDoubloonEvents(DATA_PATH, DATA_KEY) { }
}