// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestSafeMath.sol";

contract PublicTest1 is TestSafeMath {
    string PATH = "test/data/safemath.json";
    string KEY = "[0]";
    constructor() TestSafeMath(PATH, KEY) { } 
}

contract PublicTest2 is TestSafeMath {
    string PATH = "test/data/safemath.json";
    string KEY = "[1]";
    constructor() TestSafeMath(PATH, KEY) { } 
}

contract PublicTest3 is TestSafeMath {
    string PATH = "test/data/safemath.json";
    string KEY = "[2]";
    constructor() TestSafeMath(PATH, KEY) { } 
}

contract PublicTest4 is TestSafeMath {
    string PATH = "test/data/safemath.json";
    string KEY = "[3]";
    constructor() TestSafeMath(PATH, KEY) { } 
}
