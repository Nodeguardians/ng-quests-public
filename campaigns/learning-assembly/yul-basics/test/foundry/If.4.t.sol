// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestIf.sol";

contract PublicTest1 is TestIf {
    string PATH = "test/data/if.json";
    string KEY = "[0]";
    constructor() TestIf(PATH, KEY) { } 
}

contract PublicTest2 is TestIf {
    string PATH = "test/data/if.json";
    string KEY = "[1]";
    constructor() TestIf(PATH, KEY) { } 
}
