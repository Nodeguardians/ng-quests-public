// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestAmuletCreation.sol";

contract PublicTest1 is TestAmuletCreation {
    string DATA_PATH = "test/data/amuletCreation.json";
    string DATA_KEY = "[0]";
    constructor() TestAmuletCreation(DATA_PATH, DATA_KEY) { }
}