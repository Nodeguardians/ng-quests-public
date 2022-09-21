// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract MaagiriTrial {

    bytes32 private constant NO_SHAPE = keccak256("");
    bool public isPassed;

    mapping(address => bytes32) private firstShapes;

    function firstStage() external {
        firstShapes[msg.sender] = _getShape(msg.sender);
    }

    function secondStage() external {
        bytes32 firstShape = firstShapes[msg.sender];
        require(firstShape != 0, "First stage not attempted.");

        bytes32 secondShape = _getShape(msg.sender);
        require(firstShape != secondShape, "Failed to shapeshift");

        isPassed = true;
    }

    function _getShape(address entity) private view returns (bytes32 shape) {
        assembly { 
            shape := extcodehash(entity) 
        }
        require(shape != NO_SHAPE, "Entity has no shape.");
    }

}