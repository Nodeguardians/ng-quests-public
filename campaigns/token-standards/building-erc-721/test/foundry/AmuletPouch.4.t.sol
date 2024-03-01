// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestAmuletPouch.sol";

contract PublicTest1 is TestAmuletPouch {
    string DATA_PATH = "test/data/amuletPouch.json";
    string DATA_KEY = "[0]";
    constructor() TestAmuletPouch(DATA_PATH, DATA_KEY) { }
}