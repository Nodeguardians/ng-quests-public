// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Masks {

    /// @notice Set all the bits set in mask to 1 in x.
    function setMask(uint256 x, uint256 mask)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            
        }
    }

    /// @notice Set all the bits set in mask to 0 in x.
    function clearMask(uint256 x, uint256 mask)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            
        }
    }

    /// @notice Get 8 bytes from `x` starting from byte `at` (from the right).
    /// @param x value to extract 8 bytes from.
    /// @param at little endian index.
    function get8BytesAt(uint256 x, uint256 at)
        public
        pure
        returns (uint64 rvalue)
    {
        assembly {
            
        }
    }
}
