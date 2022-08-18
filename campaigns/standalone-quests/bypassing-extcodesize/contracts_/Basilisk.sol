// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./interfaces/IChallenger.sol";

contract Basilisk {

    mapping(address => bool) public entered;
    bool public isSlain;

    function _isContract(address account) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function enter() external {
        require(!_isContract(msg.sender), "The Basilisk detects a contract!");

        // The Basilisk allows you to enter...
        entered[msg.sender] = true;
    }

    function slay() external {
        require(entered[msg.sender], "You have not entered the den!");
        isSlain = IChallenger(msg.sender).challenge();
    }
    
}