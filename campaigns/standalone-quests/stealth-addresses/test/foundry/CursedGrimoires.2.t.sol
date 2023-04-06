// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestCursedGrimoires.sol";

contract PublicTest1 is TestCursedGrimoires {

    string PATH = "test/data/cursedGrimoires.json";
    string KEY = "[0]";
    constructor() TestCursedGrimoires(PATH, KEY) {}

}

contract PublicTest2 is TestCursedGrimoires {

    string PATH = "test/data/cursedGrimoires.json";
    string KEY = "[1]";
    constructor() TestCursedGrimoires(PATH, KEY) {}

}