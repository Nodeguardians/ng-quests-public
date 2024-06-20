// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev Deployed on OP Sepolia
contract L2LonelyHill {

    address private constant crossDomainMessenger 
        = 0x4200000000000000000000000000000000000007;

    mapping(address => bool) private hasCutTree;

    /// @dev Only accepts calls originating from L1.
    function cutSingingTree(address _user) external {
        require(msg.sender == crossDomainMessenger, "Not from L1");
        hasCutTree[_user] = true;
    }
    
    /// @dev Returns the wood of a singing tree, represented as a secret bytes32 hash.
    /// The caller must have cut the singing tree.
    function getSingingWood() external view returns (bytes32) {
        require(
            hasCutTree[msg.sender], 
            "msg.sender has not cut tree"
        );
        
        // "???" is placeholder for actual secret value
        return "???";
    }

}
