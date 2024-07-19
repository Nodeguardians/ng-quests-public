// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageVoting.sol";
import "../../../contracts/interfaces/IVillageVoting.sol";

abstract contract TestVillageVoting is Test {
    using stdJson for string;

    struct VoteInput {
        uint256[] votedAmounts;
        uint256[] votedProposals;
        address voter;
    }

    string jsonData;

    IVillageVoting vv;

    // Set up variables
    address[] villagers;
    uint256[] tokenBalances;
    uint256[] proposals;
    
    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function setUp() external {
        villagers = jsonData.readAddressArray(".setup.villagers");
        tokenBalances = jsonData.readUintArray(".setup.tokenBalances");
        proposals = jsonData.readUintArray(".setup.proposals");

        address vvAddress = address(
            new VillageVoting(
                villagers, 
                tokenBalances, 
                proposals
            )
        );

        vv = IVillageVoting(vvAddress);
    }

    function test_correct_deployment() external {

        // 1. Check balanceOf for each villager
        for (uint256 i; i < villagers.length; ++i) {
            uint256 actualBalance = vv.balanceOf(villagers[i]);
            assertEq(
                actualBalance, 
                tokenBalances[i],  
                "Unexpected villager balance"
            );
        }

        // 2. Check expected number of proposals
        uint256[] memory actualProposals = vv.getProposals();
        assertEq(
            actualProposals.length, 
            proposals.length, 
            "Unexpected number of proposals"
        );

        // 3. Check proposals (order doesn't matter)
        for (uint256 i; i < actualProposals.length; ++i) {
            bool contains;
            for (uint256 j; j < actualProposals.length; ++j) {
                if (actualProposals[j] == proposals[i]) {
                    contains = true;
                    break;
                }
            }

            require(contains, "Missing proposal");
        }

    }

    function test_no_winning_proposal_before_countVotes() external {
        vm.expectRevert();
        vv.getWinningProposal();
    }

    function test_accept_valid_votes() external {

        // 1. Process each vote
        VoteInput[] memory inputs = abi.decode(
            jsonData.parseRaw(".votes"),
            (VoteInput[])
        );

        for (uint256 i; i < inputs.length; ++i) {
            vm.prank(inputs[i].voter);
            vv.vote(
                inputs[i].votedProposals, 
                inputs[i].votedAmounts
            );
        }

        // 2. Check final vote power
        uint256[] memory expectedVotePower
            = jsonData.readUintArray(".expectedVotePower");

        for (uint256 i; i < proposals.length; ++i) {
            uint256 actualVotePower = vv.votePower(proposals[i]);

            assertEq(
                actualVotePower, 
                expectedVotePower[i], 
                "Unexpected final vote power"
            );
        }

    }
    
    function test_count_votes() external {

        // 1. Process each vote
        VoteInput[] memory inputs = abi.decode(
            jsonData.parseRaw(".votes"),
            (VoteInput[])
        );

        for (uint256 i; i < inputs.length; ++i) {
            vm.prank(inputs[i].voter);
            vv.vote(
                inputs[i].votedProposals, 
                inputs[i].votedAmounts
            );
        }

        // 2. Count votes
        vm.warp(block.timestamp + 7 days + 1);
        vv.countVotes();

        // 3. Check winner
        uint256 expectedWinner 
            = jsonData.readUint(".expectedWinner");

        assertEq(
            vv.getWinningProposal(), 
            expectedWinner, 
            "Unexpected winner"
        );

    }

    function test_reject_double_vote() external {

        VoteInput memory input = abi.decode(
            jsonData.parseRaw(".votes[0]"),
            (VoteInput)
        );

        // 1. Vote once
        vm.prank(input.voter);
        vv.vote(input.votedProposals, input.votedAmounts);

        // 2. Vote twice (should revert)
        vm.expectRevert();
        vm.prank(input.voter);
        vv.vote(input.votedProposals, input.votedAmounts);

    }

    function test_reject_vote_after_7_days() external {

        VoteInput memory input = abi.decode(
            jsonData.parseRaw(".votes[0]"),
            (VoteInput)
        );
        
        // 1. Close voting round
        vm.warp(block.timestamp + 7 days + 1);

        // 2. Vote (should revert)
        vm.expectRevert();
        vm.prank(input.voter);
        vv.vote(input.votedProposals, input.votedAmounts);

    }

    function test_reject_vote_with_insufficient_tokens() external {

        VoteInput memory input = abi.decode(
            jsonData.parseRaw(".votes[0]"),
            (VoteInput)
        );
        
        // 1. Over-increase vote amount 
        uint256 balance = vv.balanceOf(input.voter);
        for (uint256 i; i < input.votedAmounts.length; ++i) {
            balance -= input.votedAmounts[i];
        }
        input.votedAmounts[0] += balance + 1;

        // 2. Vote (should revert)
        vm.expectRevert();
        vm.prank(input.voter);
        vv.vote(input.votedProposals, input.votedAmounts);

    }

    function test_invalid_vote_inexistent_proposal() external {

        VoteInput memory input = abi.decode(
            jsonData.parseRaw(".inexistentProposalVote"),
            (VoteInput)
        );

        // 1. Vote with inexistent proposal (should revert)
        vm.expectRevert();
        vm.prank(input.voter);
        vv.vote(input.votedProposals, input.votedAmounts);

    }

    function test_invalid_vote_duplicate_proposals() external {
        VoteInput memory input = abi.decode(
            jsonData.parseRaw(".duplicateProposalVote"),
            (VoteInput)
        );

        // 1. Vote with duplicate proposal (should revert)
        vm.expectRevert();
        vm.prank(input.voter);
        vv.vote(input.votedProposals, input.votedAmounts);

    }


    function test_reject_counting_before_7_days() external {

        // 1. Process each vote
        VoteInput[] memory inputs = abi.decode(
            jsonData.parseRaw(".votes"),
            (VoteInput[])
        );

        for (uint256 i; i < inputs.length; ++i) {
            vm.prank(inputs[i].voter);
            vv.vote(
                inputs[i].votedProposals, 
                inputs[i].votedAmounts
            );
        }

        // 2. Count votes before 7 days (should revert)
        vm.expectRevert();
        vv.countVotes();

    }


}