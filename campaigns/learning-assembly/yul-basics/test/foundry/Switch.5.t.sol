// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestSwitch.sol";

contract PublicTest1 is TestSwitch {
    string PATH = "test/data/switch.json";
    string KEY = "[0]";
    constructor() TestSwitch(PATH, KEY) { } 
}

contract PublicTest2 is TestSwitch {
    string PATH = "test/data/switch.json";
    string KEY = "[1]";
    constructor() TestSwitch(PATH, KEY) { } 
}
