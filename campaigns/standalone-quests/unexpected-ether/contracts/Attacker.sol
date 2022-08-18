// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./SimpleGameV1.sol";

contract Attacker {
    /// @notice Wins a Silverfish game by claiming the pool money successfully
    /// @param game address of simple game to win
    function attack(SimpleGameV1 game) public payable {}
}
