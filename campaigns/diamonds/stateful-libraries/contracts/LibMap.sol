// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library LibMap {

    /// @notice Adds the path `from -> to` to the set of known paths.
    function addPath(string memory from, string memory to) internal {
        // IMPLEMENT THIS
    }

    /// @notice If the path `currentLocation() -> to` is known, sets current location as `to` and returns true.
    /// If path is not known, returns false.
    function travel(string memory to) internal returns (bool) { 
        // IMPLEMENT THIS
    }

    /// @notice Returns current location.
    /// Initially set to "harbor".
    function currentLocation() internal view returns (string memory) {
        // IMPLEMENT THIS
    }

}