// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

/// @title Interface for Crates
interface ICrates {

    /// @notice Inserts a crate into the contract. Fails if id belongs to an existing crate.
    function insertCrate(
        uint id, 
        uint size, 
        uint strength
    ) external;

    /// @notice Retrieves a crate based on id. Fails if id does not belong to an existing crate.
    function getCrate(uint id) external view returns (uint size, uint strength);

    /// @notice Retrieve the IDs of all existing crates.
    function getCrateIds() external view returns (uint[] memory);

    /// @notice Delete a crate by id. Fails if id doesn't belong to an existing crate.
    function deleteCrate(uint id) external;

}