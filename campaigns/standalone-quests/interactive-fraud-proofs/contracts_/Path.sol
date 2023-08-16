// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Path {

    enum Step {
        None,
        Up,
        Down,
        Left,
        Right
    }

    Step[] public steps;

    constructor(Step[] memory _steps) {
        steps = _steps;
    }

    /// @notice Advances a story forward by one step.
    function step(bytes32 _story, uint256 _stepNumber) 
        external 
        view 
        returns (bytes32 nextStory) 
    {
        return keccak256(abi.encode(_story, steps[_stepNumber]));
    }

    /// @notice Return the length of the path (i.e., number of steps).
    function getNumSteps() external view returns (uint256) {
        return steps.length;
    }

}