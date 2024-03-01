// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestMintableDoubloon.sol";

contract PublicTest1 is TestMintableDoubloon {
    string DATA_PATH = "test/data/mintableDoubloon.json";
    string DATA_KEY = "[0]";
    constructor() TestMintableDoubloon(DATA_PATH, DATA_KEY) { }
}

contract PublicTest2 is TestMintableDoubloon {
    string DATA_PATH = "test/data/mintableDoubloon.json";
    string DATA_KEY = "[1]";
    constructor() TestMintableDoubloon(DATA_PATH, DATA_KEY) { }
}