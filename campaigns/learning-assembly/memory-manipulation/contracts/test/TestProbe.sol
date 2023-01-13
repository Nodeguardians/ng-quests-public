// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "../FreeMemoryPointer.sol";
import "../MemoryLayout.sol";
import "../DynamicArray.sol";

/// @dev For testing purposes
contract TestProbe is FreeMemoryPointer, MemoryLayout, DynamicArray {

    function testGetFreeMemoryPointer(uint256 size) external pure returns (string memory error) {

        uint256 fmp;

        assembly {
            fmp := add(mload(0x40), size)
            mstore(0x40, fmp)
        }

        if (getFreeMemoryPointer() != fmp) {
            return "Incorrect free memory pointer";
        }

        return "";
    }

    function testGetMaxAccessedMemory(uint256 size) external pure returns (string memory error) {

        assembly {
            mstore(size, 0x01)
        }

        if (getMaxAccessedMemory() != size + 0x20) {
            return "Incorrect maximum accessed memory address";
        }

        return "";
    }

    function testAllocateMemory(uint256 size) external pure returns (string memory error) {

        // Ensure that the test always start with a clean memory pointer
        // We start with the default initial free memory pointer value 0x80
        assembly {
            mstore(0x40, 0x80)
        }

        uint256 addr = allocateMemory(size);
        uint256 fmp;

        assembly {
            fmp := mload(0x40)
        }

        if (addr != 0x80) {
          return "Invalid return value";
        } else if (fmp != 0x80 + size) {
            return "Invalid memory allocation";
        }

        return "";
    }

    function testFreeMemory(
        uint256 allocated, 
        uint256 size
    ) external pure returns (string memory error) {

        // Ensure that the test always start with a clean memory pointer
        // We start with 32 bytes of "allocated" memory
        assembly {
            mstore(0x40, add(0x80, allocated))
        }

        freeMemory(size);
        uint256 fmp;

        assembly {
            fmp := mload(0x40)
        }

        if (fmp != 0x80 + allocated - size) {
           return "Unexpected free memory pointer value";
        }

        return "";
    }

    function testCreateUint256Array(
        uint256 size, 
        uint256 value
    ) external pure returns (string memory error)  {

        uint256[] memory array = new uint256[](size);
        uint256 _arrayAddress;
        uint256 fmpBefore;
        uint256 fmpAfter;

        for (uint256 i = 0; i < size; i++) {
            array[i] = value;
        }

        assembly {
            fmpBefore := mload(0x40)
        }

        uint256[] memory _array = createUintArray(size, value);

        assembly {
            _arrayAddress := _array
            fmpAfter := mload(0x40)
        }

        if (_arrayAddress != fmpBefore) {
            return  "Array not created at start of free memory";
        }

        uint256 expectedFmp = fmpBefore + 0x20 * (size + 1);
        if (expectedFmp != fmpAfter) {
            return "Memory not properly allocated";
        }

        if (!_isEqualArrays(array, _array)) {
            return "Unexpected array content";
        }

        return "";

    }

    function testCreateBytesArray(
        uint256 size, 
        bytes1 value
    ) external pure returns (string memory error) {
        bytes memory array = new bytes(size);
        uint256 _arrayAddress;
        uint256 fmpBefore;
        uint256 fmpAfter;

        for (uint256 i = 0; i < size; i++) {
            array[i] = value;
        }

        assembly {
            fmpBefore := mload(0x40)
        }

        bytes memory _array = createBytesArray(size, value);

        assembly {
            _arrayAddress := _array
            fmpAfter := mload(0x40)
        }

        if (_arrayAddress != fmpBefore) {
            return  "Array not created at start of free memory";
        }

        uint256 expectedFmp = fmpBefore + 0x20 + size;
        if (expectedFmp != fmpAfter) {
            return "Memory not properly allocated";
        }

        if (keccak256(array) != keccak256(_array)) {
            return "Unexpected array content";
        }

        return "";

    }

    function testPush(
        uint256[] memory before, 
        uint256 value, 
        uint256[] memory _after
    ) public pure returns (string memory error) {

        uint256 fmpBefore;
        uint256 _arrayAddress;
        uint256 fmpAfter;

        assembly {
            fmpBefore := mload(0x40)
        }

        uint256[] memory newArray = push(before, value);

        assembly {
            fmpAfter := mload(0x40)
            _arrayAddress := newArray
        }

        if (_arrayAddress != fmpBefore) {
            return "Array not created at start of free memory";
        }


        uint256 expectedFmp = fmpBefore + 0x40 + 0x20 * before.length;
        if (expectedFmp != fmpAfter) {
            return "Memory not properly allocated";
        }

        if (!_isEqualArrays(newArray, _after)) {
            return "Unexpected array content";
        }

        return "";
    }

    function testPop(
        uint256[] memory before, 
        uint256[] memory _after
    ) public pure returns (string memory error) {

        uint256 fmpBefore;
        uint256 fmpAfter;

        assembly {
            fmpBefore := mload(0x40)
        }

        pop(before);

        assembly {
            fmpAfter := mload(0x40)
        }

        if (fmpBefore != fmpAfter) {
            return "Memory was allocated";
        }
        if (!_isEqualArrays(before, _after)) {
            return "Unexpected array content";
        }

        return "";
    }

    function testPopAt(
        uint256[] memory before, 
        uint256 index, 
        uint256[] memory _after
    ) public pure returns (string memory error) {

        uint256 fmpBefore;
        uint256 fmpAfter;

        assembly {
            fmpBefore := mload(0x40)
        }

        popAt(before, index);

        assembly {
            fmpAfter := mload(0x40)
        }

        if (fmpBefore != fmpAfter) {
            return "Memory was allocated";
        }

        if (!_isEqualArrays(before, _after)) {
            return "Unexpected array content";
        }

        return "";
    }
    
    function _isEqualArrays(
        uint256[] memory arr1, 
        uint256[] memory arr2
    ) private pure returns (bool) {
        bytes32 hash1 = keccak256(abi.encodePacked(arr1));
        bytes32 hash2 = keccak256(abi.encodePacked(arr2));

        return hash1 == hash2;
    }

}
