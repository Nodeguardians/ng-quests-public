// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageFunding.sol";
import "../../../contracts/interfaces/IVillageFunding.sol";
import "../../../contracts/test/ReentrancyAttacker.sol";

abstract contract TestVillageFunding is Test {
    using stdJson for string;

    struct ContributionInput {
        uint256 amount;
        address project;
        address villager;
    }

    string jsonData;

    IVillageFunding vf;

    // Set up variables
    address[] villagers;
    address[] projects;
    uint256 matchingAmount;
    
    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function setUp() external {
        villagers = jsonData.readAddressArray(".setup.villagers");
        projects = jsonData.readAddressArray(".setup.projects");
        matchingAmount = jsonData.readUint(".setup.matchingAmount");

        address vfAddress = address(
            new VillageFunding{ value: matchingAmount }(
                villagers, 
                projects
            )
        );

        vf = IVillageFunding(vfAddress);
    }

    function test_correct_deployment() external {

        // 1. Check expected number of projects
        address[] memory actualProjects = vf.getProjects();
        assertEq(
            actualProjects.length, 
            projects.length, 
            "Unexpected number of projects"
        );

        // 2. Check proposals (order doesn't matter)
        for (uint256 i; i < actualProjects.length; ++i) {
            bool contains;
            for (uint256 j; j < actualProjects.length; ++j) {
                if (actualProjects[j] == projects[i]) {
                    contains = true;
                    break;
                }
            }

            require(contains, "Missing project");
        }

    }

    function test_finalFunds_zero_before_finalizeFunds() external {
        // 1. Process each contribution
        _processContributions();
        // 2. Check final funds == 0
        uint256 finalFunds = vf.finalFunds(projects[0]);
        assertEq(finalFunds, 0, "Unexpected final funds");
    }

    function test_accept_contributions_and_finalizeFunds() external {

        // 1. Process each contribution
        _processContributions();

        // 2. Finalize Funds
        vm.warp(block.timestamp + 7 days + 1);
        vf.finalizeFunds();

        // 3. Check final funds of each project
        uint256[] memory expectedFunds = jsonData.readUintArray(".expectedFunds");
        for (uint256 i; i < projects.length; ++i) {
            uint256 finalFund = vf.finalFunds(projects[i]);
            assertEq(
                finalFund, 
                expectedFunds[i], 
                "Unexpected final funds"
            );
        }

    }

    function test_withdrawals() external {

        // 1. Process each contribution
        _processContributions();

        // 2. Finalize Funds
        vm.warp(block.timestamp + 7 days + 1);
        vf.finalizeFunds();

        // 3. Test withdraw for each project
        for (uint256 i; i < projects.length; ++i) {
            uint256 finalFund = vf.finalFunds(projects[i]);
            vm.prank(projects[i]);
            vf.withdraw();

            assertEq(
                projects[i].balance, 
                finalFund,
                "Unexpected project balance"
            );

            assertTrue(
                vf.finalFunds(projects[i]) == 0,
                "Final funds should be zero after withdrawal"
            );

        }

    }

    function test_reject_double_contribution() external {

        ContributionInput memory input = abi.decode(
            jsonData.parseRaw(".contributions[0]"),
            (ContributionInput)
        );

        // 1. Vote once
        hoax(input.villager);
        vf.donate{ value: input.amount }(input.project);

        // 2. Vote twice (should revert)
        vm.expectRevert();
        hoax(input.villager);
        vf.donate{ value: input.amount }(input.project);

    }

    function test_reject_contribution_after_7_days() external {

        ContributionInput memory input = abi.decode(
            jsonData.parseRaw(".contributions[0]"),
            (ContributionInput)
        );
        
        // 1. Close funding period
        vm.warp(block.timestamp + 7 days + 1);

        // 2. Contribute (should revert)
        vm.expectRevert();
        hoax(input.villager);
        vf.donate{ value: input.amount }(input.project);

    }

    function test_reject_contribution_to_inexistent_project() external {

        ContributionInput memory input = abi.decode(
            jsonData.parseRaw(".inexistentProjectContribution"),
            (ContributionInput)
        );

        // 1. Contribute to inexistent project (should revert)
        vm.expectRevert();
        hoax(input.villager);
        vf.donate{ value: input.amount }(
            input.project
        );

    }

    function test_reject_contribution_from_nonVillager() external {

        ContributionInput memory input = abi.decode(
            jsonData.parseRaw(".nonVillagerContribution"),
            (ContributionInput)
        );

        // 1. Contribute (should revert)
        vm.expectRevert();
        hoax(input.villager);
        vf.donate{ value: input.amount }(
            input.project
        );

    }

    function test_reject_finalizeFunds_before_7_days() external {

        // 1. Process each contribution
        _processContributions();

        // 2. Finalize Funds before 7 days (should revert)
        vm.expectRevert();
        vf.finalizeFunds();

    }


    function test_invalid_withdrawals() external {

        // 1. Process each contribution
        _processContributions();

        // 2. Finalize Funds
        vm.warp(block.timestamp + 7 days + 1);
        vf.finalizeFunds();

        // 3. Test invalid withdrawal from non-project (should revert)
        vm.expectRevert();
        vf.withdraw();

        // 3. Test double withdrawal (should revert)

        // Use project with smaller funds
        address project;
        if (vf.finalFunds(projects[0]) < vf.finalFunds(projects[1])) {
            project = projects[0];
        } else {
            project = projects[1];
        }

        vm.prank(project);
        vf.withdraw();

        vm.expectRevert();
        vm.prank(project);
        vf.withdraw();

    }

    function test_reentrancy_attack_on_withdrawal() external {

        // 1. Process each contribution
        _processContributions();

        // 2. Finalize Funds
        vm.warp(block.timestamp + 7 days + 1);
        vf.finalizeFunds();

        // 3. Reentrancy attack on withdrawal (should revert)
        ReentrancyAttacker attacker = new ReentrancyAttacker();

        // Use project with smaller funds
        address project;
        if (vf.finalFunds(projects[0]) < vf.finalFunds(projects[1])) {
            project = projects[0];
        } else {
            project = projects[1];
        }
        
        vm.etch(project, address(attacker).code);
        vm.expectRevert();
        vm.prank(project);
        vf.withdraw();
    }

    function _processContributions() internal {
        ContributionInput[] memory inputs = abi.decode(
            jsonData.parseRaw(".contributions"),
            (ContributionInput[])
        );

        for (uint256 i; i < inputs.length; ++i) {
            hoax(inputs[i].villager);
            vf.donate{ value: inputs[i].amount }(
                inputs[i].project
            );
        }
    }
}