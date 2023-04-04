// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./testsuites/TestGrandmasters.sol";

address constant CREATOR = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
address constant OTHER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

contract PublicTest1 is Test {
    function test_initially_only_have_contract_creator_as_grandmaster() external {
        hoax(CREATOR);
        Grandmasters grandmasters = new Grandmasters{value: 1 ether}();

        assertTrue(grandmasters.grandmasters(CREATOR), "Creator is not grandmaster");
        assertTrue(!grandmasters.grandmasters(OTHER), "Another grandmaster detected");
    }
}

contract PublicTest2 is TestGrandmasters {

    string TEST_DATA_PATH = "./test/data/signatures.json";
    constructor() TestGrandmasters(TEST_DATA_PATH) { }

    function test_valid_signatures() external {
        _runTests(".valid-signatures");
    }

    function test_reject_invalid_signatures() external {
        _runTests(".invalid-signatures");
    }

    function test_resist_counter_replay() external {
        _runTests(".signature-replay");
    }

}
