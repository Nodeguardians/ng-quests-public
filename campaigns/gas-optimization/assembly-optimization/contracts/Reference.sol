// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Reference {

    /**
     * @notice Returns a copy of the given array.
     * @dev This contract will be called internally.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function referenceCopyArray(bytes memory array) 
        internal 
        pure 
        returns (bytes memory copy) 
    {
        copy = new bytes(array.length);

        for (uint256 i; i < array.length; i++) {
            copy[i] = array[i];
        }
    }
}
