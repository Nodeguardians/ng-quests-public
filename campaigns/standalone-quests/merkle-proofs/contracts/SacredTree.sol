// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SacredTree1 {

    // Insert hash here
    bytes32 public root = ???;

    /// Verify that an address is trusted by the tree.
    /// @param trustee Address to verify
    /// @param proof Merkle proof for verification
    function verify(
        address trustee, 
        bytes32[] proof) 
    external {
        // CODE HERE
    }

}
