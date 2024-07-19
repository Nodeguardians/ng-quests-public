// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestVillageFunding.sol";

contract PublicTest1 is TestVillageFunding {
    string PATH = "test/data/VillageFunding1.json";
    constructor() TestVillageFunding(PATH) {}
}

contract PublicTest2 is TestVillageFunding {
    string PATH = "test/data/VillageFunding2.json";
    constructor() TestVillageFunding(PATH) {}
}
