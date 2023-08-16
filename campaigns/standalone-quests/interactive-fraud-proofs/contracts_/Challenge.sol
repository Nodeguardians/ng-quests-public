// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Path.sol";

contract Challenge {

    enum Result {
        ChallengerWon,
        DefenderWon
    }

    bytes32 constant NULL = bytes32(0);
    uint256 constant TIMEOUT_WINDOW = 12 hours;

    address public immutable challenger;
    address public immutable defender;

    // The stories asserted by the challenger and defender
    mapping(uint256 => bytes32) public challengerStory;
    mapping(uint256 => bytes32) public defenderStory;
    
    // The path the story should follow
    Path public path;

    // Binary search boundaries
    uint256 L;
    uint256 R;

    // Latest timestamp before an action time out
    uint256 timeout;

    /**
     * @notice Create a new challenge.
     */
    constructor(
        address _challenger, 
        address _defender,
        bytes32 _beginning,
        bytes32 _challengerEnding,
        bytes32 _defenderEnding,
        Path _path
    ) {
        require(
            _challengerEnding != _defenderEnding, 
            "Challenger must disagree with defender"
        );
        uint256 numSteps = _path.getNumSteps();
        
        (challenger, defender) = (_challenger, _defender);
        (L, R) = (0, numSteps); // The initial search space is [0, numSteps]

        // Both parties agree on the story's beginninng
        challengerStory[0] = _beginning;
        defenderStory[0] = _beginning;
        
        // But disagree on the story's ending
        challengerStory[numSteps] = _challengerEnding;
        defenderStory[numSteps] = _defenderEnding;
        path = _path;
    }

    /**
     * @notice The challenger proposes what a segment of the story should be.
     * The segment to challenge is in the middle of the search space. 
     * (i.e., between L and R)
     */
    function challengeStory(bytes32 story) external {
        require(msg.sender == challenger, "msg.sender != challenger");
        require(isSearching(), "Binary search finished");
        uint256 bisectionStep = getBisectionStep();

        require(challengerStory[bisectionStep] == NULL, "Story already challenged");
        
        challengerStory[bisectionStep] = story;
        timeout = block.timestamp + TIMEOUT_WINDOW;

        // In the real world, the defender is an off-chain entity.
        // For this quest, the defender is simulated by an on-chain contract.
        _simulateDefender();
    }

    /**
     * @notice The defender responds to the challenger.
     * Either agreeing with the challenger, and moving the search right,
     * Or disagreeing with the challenger, and moving the search left.
     */
    function defendStory(bytes32 story) external {
        require(msg.sender == defender, "msg.sender != defender");
        require(isSearching(), "Binary search finished");

        uint256 bisectionStep = getBisectionStep();

        require(challengerStory[bisectionStep] != NULL, "Story not challenged");
        require(defenderStory[bisectionStep] == NULL, "Story already defended");

        defenderStory[bisectionStep] = story;
        timeout = block.timestamp + TIMEOUT_WINDOW;

        // Update binary search bounds
        if (challengerStory[bisectionStep] == defenderStory[bisectionStep]) {
            L = bisectionStep; // Agree
        } else {
            R = bisectionStep; // Disagree
        }
    }

    /**
     * @notice Returns the result of the challenge.
     * The challenge must be resolveable, either by timeout or verification.
     */
    function resolve() external view returns (Result) {
        // If binary search not finished, check for timeout
        if (isSearching()) {
            require(block.timestamp > timeout, "Binary search still ongoing");

            uint256 bisectionStep = getBisectionStep();
            if (challengerStory[bisectionStep] == NULL) {
                // Challenger timed out, Defender won
                return Result.DefenderWon;
            } else {
                // Defender timed out, Challenger won
                return Result.ChallengerWon;
            }
        }

        // Else, binary search finished, verify single step
        bytes32 nextStory = path.step(defenderStory[L], L);

        if (nextStory == defenderStory[R]) {
            return Result.DefenderWon;
        } else {
            return Result.ChallengerWon;
        }
    }

    /**
     * @notice Returns true if binary search is still ongoing.
     * Returns false otherwise.
     */
    function isSearching() public view returns (bool) {
        return L + 1 != R;
    }

    /**
     * @notice Returns the middle index in the search space.
     * (i.e., between L and R)
     */
    function getBisectionStep() public view returns (uint256) {
        return (L + R) / 2;
    }

    /**
     * @notice Triggers the defender to respond to the challenger.
     * In the real world, the defender is an off-chain entity.
     * But for this quest, we automate the defender as an on-chain contract.
     */
    function _simulateDefender() private {
        (bool success, ) = defender.call("");
        require(success, "defender failed");
    }
}