// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/test/TestShip.sol";

abstract contract TestLibMap is Test {

    using stdJson for string;

    struct InputStep {
        string action;
        string from;
        string to;
    }

    bytes32 constant ADDPATH_HASH = keccak256(abi.encode("AddPath"));
    string jsonData;
    TestShip ship;

    mapping(string => mapping(string => bool)) paths;

    constructor(string memory _testDataKey) {
        jsonData = vm.readFile(_testDataKey);
        ship = new TestShip();
    }

    function test_stateful_map() external {
        InputStep[] memory steps = abi.decode(
            jsonData.parseRaw(".steps"),
            (InputStep[])
        );

        string memory expectedLocation = "harbor";

        for (uint i = 0; i < steps.length; i++) {
            InputStep memory step = steps[i];

            if (keccak256(abi.encode(step.action)) == ADDPATH_HASH) {
                ship.addPath(step.from, step.to);
                paths[step.from][step.to] = true;
            } else /* step.action is "Travel" */ {
                bool hasPath = paths[expectedLocation][step.to];
                console.logBool(hasPath);
                expectedLocation = hasPath ? step.to : expectedLocation;
                ship.travelAndVerifyResults(
                    step.to, 
                    hasPath, 
                    expectedLocation
                );
            }

        }
    }

    function test_avoid_storage_clashes() external {
        uint256 slots = jsonData.readUint(".slots");
        assertTrue(ship.checkStorageClash(slots), "Storage clash detected");
    }

}