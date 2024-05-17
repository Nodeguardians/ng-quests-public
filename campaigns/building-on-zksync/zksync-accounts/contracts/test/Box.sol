// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @notice Test contract for `SummonerAccount` to interact with.
contract Box {

    uint256 public value;

    constructor(uint256 _value) {
        value = _value;
    }

    function set(uint256 _value) public {
        value = _value;
    }

}
