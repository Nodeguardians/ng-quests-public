// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/If.sol";

abstract contract TestIf is Test {

    If ifContract;

    using stdJson for string;

    int256 testMinutes;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        testMinutes = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (int256)
        );

        ifContract = new If();
    }

    function test_convert_minutes_to_hours() external {
        if (testMinutes < 0 || testMinutes % 60 > 0) {
            vm.expectRevert();
            ifContract.minutesToHours(testMinutes);
        } else {
            uint256 result = ifContract.minutesToHours(testMinutes);
            assertEq(result, uint256(testMinutes) / 60, "Unexpected Result");
        }
    }

}