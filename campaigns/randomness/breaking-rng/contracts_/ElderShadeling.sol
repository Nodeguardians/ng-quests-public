// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ElderShadeling {
    bytes32 prediction;
    uint256 blockNumber;
    bool committed;

    bool public isPredicted;

    function commitPrediction(bytes32 x) external {
        prediction = x;
        blockNumber = block.number;
        committed = true;
    }

    function checkPrediction() external {
        require(committed, "Prediction not committed");
        
        // Ensure prediction is checked at a later block.
        require(block.number > blockNumber + 1);
        require(prediction == blockhash(blockNumber + 1));
        isPredicted = true;
    }
    
}
