// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestElegy1.sol";

contract PublicTest1 is TestElegy1 {

    string TEST_DATA_PATH = "./test/data/verses.json";

    constructor() TestElegy1(TEST_DATA_PATH) { }

}
