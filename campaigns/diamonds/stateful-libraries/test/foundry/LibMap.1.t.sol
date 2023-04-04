// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestLibMap.sol";

contract PublicTest1 is TestLibMap {

    string TEST_DATA_PATH = "test/data/paths.json";
    constructor() TestLibMap(TEST_DATA_PATH) { }

}
