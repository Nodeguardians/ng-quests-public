// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestArithmetic.sol";

contract PublicTest1 is TestArithmetic {
    string PATH = "test/data/arithmetic.json";
    string KEY = "[0]";
    constructor() TestArithmetic(PATH, KEY) { } 
}
