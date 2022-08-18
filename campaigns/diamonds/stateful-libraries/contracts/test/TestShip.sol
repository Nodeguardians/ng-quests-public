// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../LibMap.sol";

/// @dev For testing purposes (Uses `LibMap`).
contract TestShip {

    function travelAndVerifyResults(
        string memory to,
        bool expectedResult,
        string memory expectedLocation
    ) external {
        require(LibMap.travel(to) == expectedResult, "Unexpected travel result");

        bytes32 expectedHash = keccak256(abi.encode(expectedLocation));
        bytes32 currentHash = keccak256(abi.encode(LibMap.currentLocation()));
        
        require(currentHash == expectedHash, "Unexpected currentLocation()");
    }

    function addPath(
        string memory from,
        string memory to
    ) external {
        LibMap.addPath(from, to);
    }


    /// @dev Returns `true` if `LibMap` is (somewhat) storage collision safe.
    /// Returns false otherwise.
    function checkStorageClash(uint256 slotCount) 
        external 
        view
        returns (bool) 
    {
        bytes32 checksum;
        assembly {
            for {let i := 0} lt(i, slotCount) {i := add(i, 1)} {
                checksum := or(checksum, sload(i))
            }
        }
        return checksum == 0;
    }

}