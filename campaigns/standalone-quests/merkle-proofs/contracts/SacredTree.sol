// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract SacredTree {

    bytes32 public root; // PART 1: STORE ROOT HERE

    /// Verify that an address is trusted by the tree.
    /// @param trustee Address to verify
    /// @param proof Merkle proof for verification
    function verify(
        address trustee, 
        bytes32[] calldata proof) 
    external view returns (bool) {
        // PART 2: CODE HERE
    }

}
