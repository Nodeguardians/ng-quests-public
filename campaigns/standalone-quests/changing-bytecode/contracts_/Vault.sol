// SPDX-License-Identifier: MIT
pragma solidity =0.8.9;

/** @dev Compilation configuration:
 * Solidity version: 0.8.9+commit.e5eed63a
 * EVM version: London
 * Optimizer: disabled
 * Source name: "./contracts_/Vault.sol"
 */
contract Vault {

    function burn() external {
        selfdestruct(payable(this));
    }
    
    receive() external payable { }

}