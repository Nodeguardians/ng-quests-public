// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./QuarryBase.sol";

contract RubyQuarry is QuarryBase {

    bytes32 private ownerHash 
        = 0x4f8bf104764038194a9323a9b61e2806a8370b9cfbe823f5a511062bf189b9d5;

    function dig() external view returns (string memory treasure) {

        bytes32 senderHash = keccak256(abi.encodePacked(msg.sender));
        require(senderHash == ownerHash, "Caller must be owner");

        return super._dig();
    }

}