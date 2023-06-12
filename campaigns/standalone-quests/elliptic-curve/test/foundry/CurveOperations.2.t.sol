// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestCurveOps.sol";

contract PublicTest1 is TestCurveOps {
    string PATH = "test/data/curveOperations.json";
    string KEY = "[0]";
    constructor() TestCurveOps(PATH, KEY) { }
}

contract PublicTest2 is TestCurveOps {
    string PATH = "test/data/curveOperations.json";
    string KEY = "[1]";
    constructor() TestCurveOps(PATH, KEY) { }
}
