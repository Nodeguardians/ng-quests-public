// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestDoubloonTransfer.sol";

contract PublicTest1 is TestDoubloonTransfer {
    string DATA_PATH = "test/data/doubloonTransfer.json";
    string DATA_KEY = "[0]";
    constructor() TestDoubloonTransfer(DATA_PATH, DATA_KEY) { }
}

contract PublicTest2 is TestDoubloonTransfer {
    string DATA_PATH = "test/data/doubloonTransfer.json";
    string DATA_KEY = "[1]";
    constructor() TestDoubloonTransfer(DATA_PATH, DATA_KEY) { }
}