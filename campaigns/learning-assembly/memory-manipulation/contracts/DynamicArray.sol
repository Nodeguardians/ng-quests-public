// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DynamicArray {

    /// @notice Copies `array` into a new memory array 
    /// and pushes `value` into the new array.
    /// @return array_ The new array to return.
    function push(
        uint256[] memory array, 
        uint256 value
    ) public pure returns (uint256[] memory array_) {
        assembly {

        }
    }

    /// @notice Pops the last element from a memory array.
    /// @dev Reverts if array is empty.
    function pop(uint256[] memory array) 
        public 
        pure 
        returns (uint256[] memory array_) 
    {
        assembly {

        }
    }

    /// @notice Pops the `index`th element from a memory array.
    /// @dev Reverts if index is out of bounds.
    function popAt(uint256[] memory array, uint256 index) 
        public 
        pure 
        returns (uint256[] memory array_) 
    {
        assembly {
            
        }
    }

}