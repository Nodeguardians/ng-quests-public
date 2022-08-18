// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Shadeling {
    bool public isPredicted;

    function predict(bytes32 x) external {
        require(x == _random());
        isPredicted = true;
    }

    function _random() internal view returns (bytes32) {
        return keccak256(abi.encode(block.timestamp));
    }
}
