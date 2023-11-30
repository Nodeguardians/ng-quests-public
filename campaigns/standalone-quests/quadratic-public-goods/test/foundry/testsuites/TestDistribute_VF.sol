// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageFunding.sol";

contract TestDistribute_VF is Test {
    using stdJson for string;

    struct Setup {
        uint256 distributionTime;
        uint256[] donations;
        uint256[] projects;
        address[] villagers;
        uint256 voteDuration;
    }

    struct Vote {
        uint256 projectId;
        uint256 vote;
        address voter;
    }

    struct Result {
        uint256[] funds;
        bool shouldFail;
    }

    string jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }   

    function _test_distribute(string memory key) internal {
        (Setup memory setup, Vote[] memory votes, Result memory result) 
            = _readInputs(key);

        // Set up VillageFunding
        VillageFunding vf = new VillageFunding(
            setup.villagers, 
            setup.projects, 
            setup.voteDuration
        );

        for (uint256 i; i < setup.donations.length; ++i) {
            hoax(setup.villagers[i]);
            vf.donate{value: setup.donations[i]}();
        }

        for (uint256 i; i < votes.length; ++i) {
            vm.prank(votes[i].voter);
            vf.vote(votes[i].projectId, votes[i].vote);
        }

        // Test distributes before distribution time
        vm.expectRevert();
        vf.distribute();
        
        vm.warp(block.timestamp + setup.distributionTime);

        if (result.shouldFail) {
            vm.expectRevert();
            vf.distribute();
            
            return;
        }

        // Should fail a non-deployer call
        vm.prank(vm.addr(42));
        (bool revertsAsExpected, ) = address(vf).call(
            abi.encodeWithSelector(vf.distribute.selector)
        );
        assertFalse(revertsAsExpected, "Should fail a non-deployer call");

        vf.distribute();

        uint256 totalAmount;
        uint256 actualFunds;
        uint256 delta;
        for (uint256 i; i < setup.projects.length; ++i) {
            actualFunds = vf.getFunds(setup.projects[i]);
            delta = result.funds[i] * 5 / 100;
            assertApproxEqAbs(actualFunds, result.funds[i], delta, "Wrong funds");
            totalAmount += actualFunds;
        }

        assertLe(
            totalAmount, 
            address(vf).balance, 
            "Total amount should be less or equal to balance"
        );
    }

    function _readInputs(string memory key) 
        internal
        view
        returns (Setup memory, Vote[] memory, Result memory) 
    {
        string memory setupKey = string.concat(key, ".setup");
        Setup memory setup = abi.decode(jsonData.parseRaw(setupKey), (Setup));

        string memory votesKey = string.concat(key, ".votes");
        Vote[] memory votes = abi.decode(jsonData.parseRaw(votesKey), (Vote[]));

        string memory resultKey = string.concat(key, ".result");
        Result memory result = abi.decode(jsonData.parseRaw(resultKey), (Result));

        return (setup, votes, result);
    }
}