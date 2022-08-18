// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract UpgradeableMechSuit {
    
    /// @notice Constructs the contract
    /// @param _implementation Address of logic contract to be linked
    constructor(address _implementation) { }

    /// @notice Upgrades contract by updating the linked logic contract
    /// @param _implementation Address of new logic contract to be linked
    function upgradeTo(address _implementation) external { }

}