// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageFunding.sol";

contract TestDonate_VF is Test {
    using stdJson for string;

    struct Setup {
        uint256[] projects;
        address[] villagers;
        uint256 voteDuration;
    }

    struct Step {
        uint256 amount;
        uint256 donateTime;
        address donor;
        bool shouldFail;
    }

    string jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function _test_donate(string memory key) public {
        (Setup memory setup, Step[] memory steps, uint256[] memory expectedVotePower) 
            = _readInputs(key);

        VillageFunding vf = new VillageFunding(
            setup.villagers, 
            setup.projects, 
            setup.voteDuration
        );

        uint256 totalAmount;
        for (uint256 i; i < steps.length; ++i) {
            Step memory step = steps[i];
            
            vm.warp(block.timestamp + step.donateTime);
            hoax(step.donor);

            if (step.shouldFail) {
                vm.expectRevert();
                vf.donate{value: step.amount}();

                continue;
            }

            vf.donate{value: step.amount}();
            totalAmount += step.amount;          
            vm.warp(block.timestamp - step.donateTime);
        }

        for (uint256 i; i < setup.villagers.length; ++i) {
            uint256 actualVotePower = vf.getVotePower(setup.villagers[i]);
            uint256 delta = expectedVotePower[i] * 5 / 100;
            assertApproxEqAbs(actualVotePower, expectedVotePower[i], delta, "Wrong vote power");
        }

        assertEq(address(vf).balance, totalAmount, "Wrong balance");
    }

    function _readInputs(string memory key) 
        private 
        view
        returns (Setup memory, Step[] memory, uint256[] memory) 
    {
        string memory setupKey = string.concat(key, ".setup");
        Setup memory setup = abi.decode(jsonData.parseRaw(setupKey), (Setup));

        string memory stepsKey = string.concat(key, ".steps");
        Step[] memory steps = abi.decode(jsonData.parseRaw(stepsKey), (Step[]));

        string memory resultKey = string.concat(key, ".votePower");
        uint256[] memory votePower = abi.decode(jsonData.parseRaw(resultKey), (uint256[]));

        return (setup, steps, votePower);
    }
}

