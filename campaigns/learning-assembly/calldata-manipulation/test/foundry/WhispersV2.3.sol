// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestWhispersV2.sol";

contract PublicTest1 is TestWhispersV2 {

    string PATH = "test/data/whispersV2.json";
    string KEY = "[0]";
    constructor() TestWhispersV2(PATH, KEY) { }

}

contract PublicTest2 is TestWhispersV2 {

    string PATH = "test/data/whispersV2.json";
    string KEY = "[1]";
    constructor() TestWhispersV2(PATH, KEY) { }

}

contract PublicTest3 is TestWhispersV2 {

    // Empty arrays
    constructor() TestWhispersV2("", "") { }

}
