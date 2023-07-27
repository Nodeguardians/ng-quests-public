// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Callee {

    address immutable self;
    uint256 public value;

    constructor(uint256 _value) {
        self = address(this);
        value = _value;
    }

    function callPure() external pure returns (uint256) {
        return 1;
    }

    function callView() external view returns (uint256) {
        return value;
    }

    function delegateCall(uint256 _value) external returns (address, address, address) {
        value = _value;
        return (msg.sender, address(this), self);
    }

    function getContext() external view returns (address, address, address, address) {
        return (tx.origin, msg.sender, address(this), self);
    }

    function call(uint256 _value) external returns (uint256) {
        value = _value;
        return value;
    }
    
    function callRevert(uint256 _value) external returns (uint256) {
        value = _value;
        revert("This function should revert");
    }

    function callPureRevert() external pure {
        revert("This function should revert");
    }
}