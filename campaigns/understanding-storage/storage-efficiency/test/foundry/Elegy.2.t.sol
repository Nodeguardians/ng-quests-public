// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestElegy2.sol";

string constant TEST_DATA_PATH = "./test/data/songs.json";

contract PublicTest1 is TestElegy2 {

    constructor() TestElegy2(TEST_DATA_PATH, "[0]") { }

}

contract PublicTest2 is TestElegy2 {

    constructor() TestElegy2(TEST_DATA_PATH, "[1]") { }

}
