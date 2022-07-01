// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ElderShadeling {
    bytes32 prediction;
    uint256 blockNumber;

    bool public isPredicted;

    function commitPrediction(bytes32 x) external {
        prediction = x;
        blockNumber = block.number;
    }

    function checkPrediction() external {
        // Ensure prediction is checked at a later block.
        require(block.number - 1 > blockNumber);

        require(prediction == blockhash(block.number - 1));
        isPredicted = true;
    }
}
