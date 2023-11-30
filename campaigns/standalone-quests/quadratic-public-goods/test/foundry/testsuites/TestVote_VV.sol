// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageVoting.sol";

contract TestVote_VV is Test {
    using stdJson for string;
    string jsonData;

    struct Setup {
        uint256[] proposals;
        uint256 roundDuration;
        address[] villagers;
        uint256[] voteTokens;
    }

    struct Step {
        uint256[] proposalIds;
        bool shouldFail;
        address voter;
        uint256[] votes;
        uint256 votingTime;
    }

    struct Results {
        bool[] hasVoted;
        uint256[] votes;
    }

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function _test_votes(string memory key) internal {
        (Setup memory setup, Step[] memory steps, Results memory results) 
            = _readInputs(key);

        // Set up VillageVoting
        VillageVoting vv = new VillageVoting(
            setup.villagers, 
            setup.voteTokens, 
            setup.proposals, 
            setup.roundDuration
        );

        // Execute Steps
        for (uint256 i; i < steps.length; ++i) {
            Step memory step = steps[i];
            vm.warp(block.timestamp + step.votingTime);
            vm.prank(step.voter);

            if (step.shouldFail) {
                vm.expectRevert();
            }

            vv.vote(step.proposalIds, step.votes);
            vm.warp(block.timestamp - step.votingTime);
        }

        // Check Results
        (, uint256 round,) = vv.getRoundInfo();
        for (uint256 i; i < results.votes.length; ++i) {
            uint256 votes = vv.getProposalVotePower(setup.proposals[i], round);
            uint256 delta = results.votes[i] * 5 / 100;
            assertApproxEqAbs(votes, results.votes[i], delta, "Wrong votes");
        }
    }

    function _readInputs(string memory key) 
        private 
        view
        returns (Setup memory, Step[] memory, Results memory) 
    {
        string memory setupKey = string.concat(key, ".setup");
        Setup memory setup = abi.decode(jsonData.parseRaw(setupKey), (Setup));

        string memory stepsKey = string.concat(key, ".steps");
        Step[] memory steps = abi.decode(jsonData.parseRaw(stepsKey), (Step[]));

        string memory resultsKey = string.concat(key, ".results");
        Results memory results = abi.decode(jsonData.parseRaw(resultsKey), (Results));
        
        return (setup, steps, results);
    }
}