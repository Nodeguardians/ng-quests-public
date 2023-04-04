// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestForTreasure.sol";

contract PublicTest1 is TestForTreasure {

    bytes32 constant EXPECTED_HASH 
        = 0x37624ea007df73dcf742c012ecd6b45423a79e118153e712c2b51ed33779dcff;
        
    constructor() TestForTreasure(2, EXPECTED_HASH) { }

}