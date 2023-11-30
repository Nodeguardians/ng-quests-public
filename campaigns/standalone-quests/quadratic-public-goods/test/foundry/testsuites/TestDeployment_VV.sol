// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageVoting.sol";

contract TestDeployment_VV is Test {
    using stdJson for string;

    struct Input {
        uint256[] proposals;
        uint256 roundDuration;
        address[] villagers;
        uint256[] voteTokens;
    }

    string jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function _test_valid_deployment(string memory key) internal {
        Input memory inputs = _readInputs(key);

        VillageVoting vv = new VillageVoting(
            inputs.villagers, 
            inputs.voteTokens, 
            inputs.proposals, 
            inputs.roundDuration
        );

        uint256 totalVotesExpected;
        uint256 totalVotes;
        uint256 villagerBalance;
        for (uint256 i; i < inputs.villagers.length; ++i) {
            villagerBalance = vv.balanceOf(inputs.villagers[i]);
            assertEq(
                villagerBalance, 
                inputs.voteTokens[i],  
                "Wrong villager balance"
            );
            totalVotes += villagerBalance;
            totalVotesExpected += inputs.voteTokens[i];
        }

        uint256[] memory activeProposals = vv.getActiveProposals();
        assertEq(
            activeProposals.length, 
            inputs.proposals.length, 
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
                inputs.proposals, 
                "Wrong active proposals"
            );
        }

        (uint256 winner, , uint256 roundEndTime) = vv.getRoundInfo();
        assertEq(totalVotes, totalVotesExpected, "Wrong total votes");
        assertEq(winner, 0, "Wrong winner");
        assertEq(
            roundEndTime, 
            block.timestamp + inputs.roundDuration, 
            "Wrong round end time"
        );
    }

    function _test_invalid_deployment(string memory key) internal {
        Input memory inputs = _readInputs(key);
        vm.expectRevert();
        new VillageVoting(
            inputs.villagers, 
            inputs.voteTokens, 
            inputs.proposals, 
            inputs.roundDuration
        );
    }

    function _readInputs(string memory key) private view returns (Input memory) {
        bytes memory rawData = jsonData.parseRaw(key);
        return abi.decode(rawData, (Input));
    }
    
}