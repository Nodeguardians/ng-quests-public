// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestDynamicArray.sol";

contract PublicTest1 is TestDynamicArray {
    string PATH = "test/data/dynamicArray.json";
    string KEY = "[0]";
    constructor() TestDynamicArray(PATH, KEY) { } 
}

contract PublicTest2 is TestDynamicArray {
    string PATH = "test/data/dynamicArray.json";
    string KEY = "[1]";
    constructor() TestDynamicArray(PATH, KEY) { } 
}
