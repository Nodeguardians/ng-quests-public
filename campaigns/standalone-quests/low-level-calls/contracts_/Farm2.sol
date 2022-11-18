// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Farm2 {

    uint256 public seedCount;

    function driveTractor(
        address _tractor, 
        bytes calldata _instructions
    ) external {
        (bool result, ) = _tractor.delegatecall(_instructions);
        require(result, "Call failed");
    }

}