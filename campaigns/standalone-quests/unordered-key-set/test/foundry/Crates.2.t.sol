// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestCrates2.sol";

contract PublicTest1 is TestCrates2 {

    string TEST_DATA_PATH = "test/data/crates.json";
    constructor() TestCrates2(TEST_DATA_PATH) { }
}
