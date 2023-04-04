// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestForTreasure.sol";

contract PublicTest1 is TestForTreasure {

    bytes32 constant EXPECTED_HASH 
        = 0x18d7f451b112d9d66d372b57a0f006069ccc3e6f27848af53713260f77ed03c2;
        
    constructor() TestForTreasure(0, EXPECTED_HASH) { }

}