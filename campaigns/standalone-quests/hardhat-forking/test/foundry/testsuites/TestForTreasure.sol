// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

abstract contract TestForTreasure is Test {

    using stdJson for string;

    uint256 immutable index;
    bytes32 immutable expectedHash;
    string[] treasures;

    constructor(uint256 _index, bytes32 _expectedHash) {
        index = _index;
        expectedHash = _expectedHash;

        string memory jsonData = vm.readFile("output/treasure.json");
        treasures = jsonData.readStringArray("");
    }

    function test_treasure_found() external {
        assertGe(treasures.length, index, "Treasure not found");

        bytes32 actualHash = keccak256(abi.encodePacked(treasures[index]));
        assertEq(actualHash, expectedHash, "Treasure Incorrect");
    }
}