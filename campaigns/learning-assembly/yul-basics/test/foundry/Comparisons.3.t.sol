// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestComparisons.sol";

contract PublicTest1 is TestComparisons {
    string TEST_DATA_PATH = "test/data/comparisons.json";
    constructor() TestComparisons(TEST_DATA_PATH) { } 
}
