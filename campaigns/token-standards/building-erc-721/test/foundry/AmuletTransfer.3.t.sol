// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./testsuites/TestAmuletTransfer.sol";

contract PublicTest1 is TestAmuletTransfer {
    string DATA_PATH = "test/data/amuletTransfer.json";
    string DATA_KEY = "[0]";
    constructor() TestAmuletTransfer(DATA_PATH, DATA_KEY) { }
}

contract PublicTest2 is TestAmuletSafeTransfer {
    string DATA_PATH = "test/data/amuletTransfer.json";
    string DATA_KEY = "[0]";
    constructor() TestAmuletSafeTransfer(DATA_PATH, DATA_KEY) { }
}

contract PrivateTest2 is TestAmuletEvents { }