// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Switch.sol";

abstract contract TestSwitch is Test {

    Switch switchContract;

    using stdJson for string;

    uint256[] ids;
    bytes8[] directions;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        ids = jsonData.readUintArray(_testDataKey);

        switchContract = new Switch();

        directions.push("left");
        directions.push("right");
        directions.push("forward");
        directions.push("backward");
    }

    function test_getDirection() external {
        for (uint i = 0; i < ids.length; i++) {
            bytes8 result = switchContract.getDirection(ids[i]);
            assertEq(result, directions[ids[i] % 4], "Unexpected Result");
        }
    }

}