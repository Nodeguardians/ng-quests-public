// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestMineCart.sol";

contract PublicTest1 is TestMineCart {
    string PATH = "test/data/mineCart.json";
    string KEY = "[0]";
    constructor() TestMineCart(PATH, KEY) { } 
}

contract PublicTest2 is TestMineCart {
    string PATH = "test/data/mineCart.json";
    string KEY = "[1]";
    constructor() TestMineCart(PATH, KEY) { } 
}