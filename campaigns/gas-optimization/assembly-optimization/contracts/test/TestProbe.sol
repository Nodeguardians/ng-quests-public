// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Reference.sol";
import "../Challenge.sol";

/// @dev For testing purposes
contract TestProbe is Challenge, Reference {

    bytes private sArray;

    function setArray(bytes memory array) external {
      sArray = array;
    }

    function testCopyArray() external view {
        bytes memory array = sArray;
        bytes memory copy;
        uint256 fmpBefore = _getFreeMemoryPointer();
        uint256 fmpAfter;
        bool matchFmp;

        copy = copyArray(array);
        fmpAfter = _getFreeMemoryPointer();

        assembly {
            matchFmp := eq(copy, fmpBefore)
        }

        if (!matchFmp || (fmpAfter - fmpBefore) < 0x20 + array.length) {
            revert("Copy was not properly allocated");
        }

        if (!_isEqualArrays(array, copy)) {
            revert("Copy doesn't match initial array");
        }
    }

    function measureReferenceCopyArray(bytes memory array) external view returns(uint256) {
        uint256 gasBefore = gasleft();
        referenceCopyArray(array);
        uint256 gasAfter = gasleft();
        return gasBefore - gasAfter;
    }

    function measureCopyArray() external view returns(uint256) {
        bytes memory array = sArray;
        uint256 gasBefore = gasleft();
        copyArray(array);
        uint256 gasAfter = gasleft();
        return gasBefore - gasAfter;
    }
    
    function _isEqualArrays(
        bytes memory arr1, 
        bytes memory arr2
    ) private pure returns (bool) {
        bytes32 hash1 = keccak256(abi.encodePacked(arr1));
        bytes32 hash2 = keccak256(abi.encodePacked(arr2));

        return hash1 == hash2;
    }

    function _getFreeMemoryPointer() internal pure returns (uint256 fmp) {
        assembly {
            fmp := mload(0x40)
        }
    }

}
