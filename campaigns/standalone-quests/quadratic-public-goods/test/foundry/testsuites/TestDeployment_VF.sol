// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/VillageFunding.sol";

contract TestDeployment_VF is Test {
    using stdJson for string;

    struct Input {
        uint256[] projects;
        address[] villagers;
        uint256 voteDuration;
    }

    string jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
    }

    function _test_valid_deployment(string memory key) internal {
        Input memory inputs = _readInputs(key);

        VillageFunding vf = new VillageFunding(
            inputs.villagers, 
            inputs.projects, 
            inputs.voteDuration
        );

        assertEq(vf.getProjects(), inputs.projects, "Wrong projects");
    }

    function _test_invalid_deployment(string memory key) internal {
        Input memory inputs = _readInputs(key);

        vm.expectRevert();
        new VillageFunding(
            inputs.villagers, 
            inputs.projects, 
            inputs.voteDuration
        );
    }

    function _readInputs(string memory key) 
        private 
        view 
        returns (Input memory)
    {
        return abi.decode(
            jsonData.parseRaw(key),
            (Input)
        );
    }
}