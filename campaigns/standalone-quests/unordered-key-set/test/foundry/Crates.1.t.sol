// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestCrates1.sol";

contract PublicTest1 is TestCrates1 {

    string TEST_DATA_PATH = "test/data/crates.json";
    constructor() TestCrates1(TEST_DATA_PATH) { }

}
