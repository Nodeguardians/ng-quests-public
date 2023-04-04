// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MaskGenerator {
    
    /// @notice Generates a mask.
    /// @param nBytes Width of mask in bytes.
    /// @param at Start of bytemask (little endian index)
    /// @param reversed If true, bytemask is a mask of 0s. Otherwise, bytemask is a regular mask of 1s.
    /// @dev Should revert if (`nBytes` + `at` > 32)
    function generateMask(
        uint256 nBytes,
        uint256 at,
        bool reversed
    ) public pure returns (uint256 mask) {
        assembly {

        }
    }
}
