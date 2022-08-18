// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Oldmancer {

    /// @dev extcodehash() of {Vault}
    bytes32 constant VAULT_HASH = 0x65d1174e06aa0f9f8d12efcb8cc03e1d7c4fa53d5c1a0fa0a66cebc6d06381c4;
    
    address public vault;

    function lockLoot(address _vault) external {

        require(_isVault(_vault), "Given address is not a vault!");
        
        uint256 loot = address(this).balance;
        require(loot > 0, "No loot to lock!");

        (bool success, ) = _vault.call{ value: loot }("");
        require(success, "Transfer failed");

        vault = _vault;
        
    }

    /**
     * @dev Verifies that `_vault` has a {Vault} contract deployed to it.
     * 
     * Uses `extcodehash()` to check the bytecode at the given address matches the bytecode of a {Vault} contract.
     */
    function _isVault(address _vault) private view returns (bool) {
        bytes32 codeHash;
        assembly { 
            codeHash := extcodehash(_vault) 
        }

        return codeHash == VAULT_HASH;
    }

    receive() external payable { }
}