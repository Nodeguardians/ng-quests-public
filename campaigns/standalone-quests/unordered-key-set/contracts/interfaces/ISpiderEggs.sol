// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/// @title Interface for SpiderEggs
interface ISpiderEggs {

    /// @notice Inserts an egg into the contract. Fails if id belongs to an existing egg.
    function insertEgg(
        uint id, 
        uint size, 
        uint strength
    ) external;

    /// @notice Retrieves an egg based on id. Fails if id does not belong to an existing egg.
    function getEgg(uint id) external view returns (uint size, uint strength);

    /// @notice Retrieve the IDs of all existing eggs.
    function getEggIds() external view returns (uint[] memory);

    /// @notice Delete an egg by id. Fails if id doesn't belong to an existing egg.
    function deleteEgg(uint id) external;

}