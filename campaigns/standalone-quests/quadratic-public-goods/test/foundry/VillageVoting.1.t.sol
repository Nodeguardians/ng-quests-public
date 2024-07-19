// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestVillageVoting.sol";

contract PublicTest1 is TestVillageVoting {
    string PATH = "test/data/VillageVoting1.json";
    constructor() TestVillageVoting(PATH) {}
}

contract PublicTest2 is TestVillageVoting {
    string PATH = "test/data/VillageVoting2.json";
    constructor() TestVillageVoting(PATH) {}
}
