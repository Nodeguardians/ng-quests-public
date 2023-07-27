// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract CreatedParams {

    uint256 public value;

    constructor(uint256 _value) payable {
        value = _value;
    }
    
}