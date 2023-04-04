// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestChallenge.sol";

contract PublicTest1 is TestSumAllExceptSkip {
    string PATH = "test/data/arrays.json";
    string KEY = ".efficiencyTests[0]";
    constructor() TestSumAllExceptSkip(PATH, KEY) { }
}

contract PublicTest2 is TestSumAllExceptSkip {
    string PATH = "test/data/arrays.json";
    string KEY = ".efficiencyTests[1]";
    constructor() TestSumAllExceptSkip(PATH, KEY) { }
}

contract PublicTest3 is TestSumAllExceptSkip {
    string PATH = "test/data/arrays.json";
    string KEY = ".efficiencyTests[2]";
    constructor() TestSumAllExceptSkip(PATH, KEY) { }
}

contract PublicTest4 is TestSumAllExceptSkipOverflow {
    string PATH = "test/data/arrays.json";
    string KEY = ".overflowTests[0]";
    constructor() TestSumAllExceptSkipOverflow(PATH, KEY) { }
}
