// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageFunding.sol";

contract TestVote_VF is Test {
    using stdJson for string;

    struct Setup {
        uint256[] donations;
        uint256[] projects;
        address[] villagers;
        uint256 voteDuration;
    }

    struct Step {
        uint256 projectId;
        bool shouldFail;
        uint256 vote;
        uint256 voteTime;
        address voter;
    }

    struct Result {
        uint256[] projectNumberOfPeople;
        uint256[] projectVotes;
        uint256[] votePower;
    }

    string jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function _test_votes(string memory key) internal {
        (Setup memory setup, Step[] memory steps, Result memory result)
            = _readInputs(key);

        VillageFunding vf = new VillageFunding(
            setup.villagers, 
            setup.projects, 
            setup.voteDuration
        );
        for (uint256 i; i < setup.donations.length; ++i) {
            hoax(setup.villagers[i]);
            vf.donate{value: setup.donations[i]}();
        }

        for (uint256 i; i < steps.length; ++i) {
            Step memory step = steps[i];
            vm.warp(block.timestamp + step.voteTime);

            if (step.shouldFail) {
                vm.expectRevert();
                vm.prank(step.voter);
                vf.vote(step.projectId, step.vote);
                vm.warp(block.timestamp - step.voteTime);

                continue;
            }

            vm.prank(step.voter);
            vf.vote(step.projectId, step.vote);
            vm.warp(block.timestamp - step.voteTime);
        }

        uint256 delta;
        for (uint256 i; i < setup.villagers.length; ++i) {
            uint256 actualVotePower = vf.getVotePower(setup.villagers[i]);
            delta = result.votePower[i] * 5 / 100;
            assertApproxEqAbs(actualVotePower, result.votePower[i], delta, "Wrong vote power");
        }

        for (uint256 i; i < setup.projects.length; ++i) {
            (uint256 votes, uint256 numberOfPeople) = 
                vf.getContributions(setup.projects[i]);
            delta = result.projectVotes[i] * 5 / 100;
            assertApproxEqAbs(votes, result.projectVotes[i], delta, "Wrong project votes");
            assertEq(
                numberOfPeople, 
                result.projectNumberOfPeople[i], 
                "Wrong project number of people"
            );
        }
    }

    function _readInputs(string memory key) 
        private 
        view
        returns (Setup memory, Step[] memory, Result memory) 
    {
        string memory setupKey = string.concat(key, ".setup");
        Setup memory setup = abi.decode(
            jsonData.parseRaw(setupKey),
            (Setup)
        );

        string memory stepsKey = string.concat(key, ".steps");
        Step[] memory steps = abi.decode(
            jsonData.parseRaw(stepsKey),
            (Step[])
        );

        string memory resultKey = string.concat(key, ".result");
        Result memory result = abi.decode(
            jsonData.parseRaw(resultKey),
            (Result)
        );

        return (setup, steps, result);
    }
}