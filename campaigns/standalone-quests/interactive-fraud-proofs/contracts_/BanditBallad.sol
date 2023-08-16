// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Challenge.sol";
import "./Path.sol";

contract BanditBallad {

    Path public immutable path;
    bytes32 public immutable beginning;
    bytes32 public ending;

    address public proposer;
    Challenge public challenge;
    uint256 public challengeWindowEnd;

    event ChallengeCreated(address challengeAddress);
    event ChallengerLoses();
    event ChallengerWins();

    /**
     * @notice Create a new ballad.
     * @param _path The path the story should follow.
     * @param _proposedEnding The proposed ending of the story.
     */
    constructor(Path _path, bytes32 _proposedEnding) {
        proposer = msg.sender;

        path = _path;
        beginning = keccak256("ballad.start");
        ending = _proposedEnding;

        // Everyone is given 7 days to challenge the proposed ending
        challengeWindowEnd = block.timestamp + 7 days;
    }

    /**
     * @notice Initiate a new challenge
     * @param _challengerEnding The challenger's ending
     */
    function initiateChallenge(bytes32 _challengerEnding) external {
        require(block.timestamp < challengeWindowEnd, "Challenge window over");
        require(ending != bytes32(0), "No ending proposed");

        // Deploy a challenge contract
        challenge = new Challenge(
            msg.sender,
            proposer,
            beginning,
            ending,
            _challengerEnding,
            path
        );

        emit ChallengeCreated(address(challenge));
    }

    /**
     * @notice Resolve an existing challenge.
     * The challenge must be resolveable.
     */
    function resolveChallenge() external {
        require(address(challenge) != address(0), "No challenge initiated");

        Challenge.Result result = challenge.resolve();
        if (result == Challenge.Result.DefenderWon) {
            // If the challenger loses, do nothing
            emit ChallengerLoses();
        } else {
            // If the challenger wins, the proposed ending is rejected
            delete ending;
            emit ChallengerWins();
        }
    }

}