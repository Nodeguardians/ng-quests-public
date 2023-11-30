// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageVoting.sol";

contract TestCountVotes_VV is Test {
    using stdJson for string;

    struct Setup {
        uint256[] proposals;
        uint256 roundDuration;
        bool shouldFail;
        address[] villagers;
        uint256[] voteTokens;
    }

    struct Step {
        uint256[] proposalIds;
        address voter;
        uint256[] votes;
    }

    struct Round {
        uint256[] activeProposals;
        uint256 countTime;
        Step[] steps;
        uint256 winner;
    }

    string jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function _test_count_votes(string memory key) public {
        (Setup memory setup, Round[] memory rounds) = _readInputs(key);

        // Set up VillageVoting
        VillageVoting vv = new VillageVoting(
            setup.villagers,
            setup.voteTokens,
            setup.proposals,
            setup.roundDuration
        );

        (uint256 winner, uint256 defaultRound, uint256 roundEndTime) = 
            vv.getRoundInfo();
        uint256 roundNumber;
        for (uint256 i; i < rounds.length; ++i) {
            (, roundNumber, roundEndTime) = vv.getRoundInfo();
            assertEq(roundNumber, i + defaultRound, "Wrong round number");
            assertEq(
                roundEndTime, 
                block.timestamp + setup.roundDuration, 
                "Wrong round end time"
            );

            Round memory round = rounds[i];
            for (uint256 j; j < round.steps.length; ++j) {
                Step memory step = round.steps[j];
                
                vm.prank(step.voter);
                vv.vote(step.proposalIds, step.votes);
            }

            vm.warp(block.timestamp + rounds[i].countTime); 
            
            if (setup.shouldFail) {
                vm.expectRevert();
                vv.countVotes();
                return;
            }

            // Should fail a non-deployer call
            vm.prank(vm.addr(42));
            (bool revertsAsExpected, ) = address(vv).call(
                abi.encodeWithSelector(vv.countVotes.selector)
            );
            assertFalse(revertsAsExpected, "Should fail a non-deployer call");

            vv.countVotes();

            (winner,,) = vv.getRoundInfo();
            assertEq(winner, rounds[i].winner, "Wrong winner");
            
            uint256[] memory activeProposals = vv.getActiveProposals();
            assertEq(
                activeProposals.length, 
                round.activeProposals.length, 
                "Wrong active proposals length"
            );
            // sort activeProposals
            if (activeProposals.length != 0) {
                for (uint256 j; j < activeProposals.length - 1; ++j) {
                    for (uint256 k; k < activeProposals.length - j - 1; ++k) {
                        if (activeProposals[k] > activeProposals[k + 1]) {
                            (activeProposals[k], activeProposals[k + 1]) = 
                            (activeProposals[k + 1], activeProposals[k]);
                        }
                    }
                }
                assertEq(
                    activeProposals, 
                    round.activeProposals, 
                    "Wrong active proposals"
                );
            }
        } 
    }

    function _readInputs(string memory key) 
        private
        returns (Setup memory, Round[] memory)
    {
        string memory setupKey = string.concat(key, ".setup");
        Setup memory setup = abi.decode(
            jsonData.parseRaw(setupKey),
            (Setup)
        );
        
        // Rounds must be parsed one-by-one to avoid StackTooDeep
        uint256 numRounds = jsonData.readUint(string.concat(key, ".numRounds"));
        Round[] memory rounds = new Round[](numRounds);
        string memory roundsKey = string.concat(key, ".rounds");

        for (uint256 i; i < numRounds; ++i) {
            string memory roundKey = string.concat(roundsKey, _indexKey(i));
            rounds[i] = abi.decode(
                jsonData.parseRaw(roundKey),
                (Round)
            );
        }

        return (setup, rounds);
    }

    function _indexKey(uint256 index) private pure returns (string memory) {
        if (index == 0) return "[0]";
        else if (index == 1) return "[1]";
        else if (index == 2) return "[2]";
        else if (index == 3) return "[3]";
        else if (index == 4) return "[4]";

        revert("Index Out of Bounds");
    }
}