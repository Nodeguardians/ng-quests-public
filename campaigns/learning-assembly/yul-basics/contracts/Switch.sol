// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Switch {
    
    /// @notice Maps the given id to a corresponding direction. 
    /// Returns "left" if id % 4 == 0.
    /// Returns "right" if id % 4 == 1.
    /// Returns "forward" if id % 4 == 2.
    /// Returns "backward" if id % 4 == 3.
    function getDirection(uint256 id)
        public
        pure
        returns (bytes8 direction)
    {
        assembly {

        }
    }
}
