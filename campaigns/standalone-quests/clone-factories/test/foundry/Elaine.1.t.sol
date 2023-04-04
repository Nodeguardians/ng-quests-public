// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestElaine.sol";

contract PublicTest1 is TestElaine {

    string TEST_DATA_PATH = "test/data/catData.json";
    constructor() TestElaine(TEST_DATA_PATH) { }

}