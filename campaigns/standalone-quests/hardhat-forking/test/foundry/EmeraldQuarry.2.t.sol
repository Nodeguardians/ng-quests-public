// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestForTreasure.sol";

contract PublicTest1 is TestForTreasure {

    bytes32 constant EXPECTED_HASH 
        = 0xf10ae9bec86eee2391ad0cfed71a6ab8bd63c437cfe4a1a65cc27dc482c8640f;

    constructor() TestForTreasure(1, EXPECTED_HASH) { }

}