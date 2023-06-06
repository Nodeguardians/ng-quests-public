// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestInstructions.sol";

contract PublicTest1 is TestInstructions {
    string PATH = "test/data/instructions.json";
    string KEY = "[0]";

    constructor() TestInstructions(PATH, KEY) {}
}

contract PublicTest2 is TestInstructions {
    string PATH = "test/data/instructions.json";
    string KEY = "[1]";

    constructor() TestInstructions(PATH, KEY) {}
}
