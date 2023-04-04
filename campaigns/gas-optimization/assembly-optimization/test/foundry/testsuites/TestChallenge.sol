// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Challenge.sol";
import "../../../contracts/test/TestProbe.sol";
import "forge-std/Test.sol";

contract TestCopyArray is Test {

    using stdJson for string;

    bytes array;
    uint256 target;
    TestProbe probe;

    constructor(
        string memory _testDataPath, 
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        array = jsonData.readBytes(
            string.concat(_testDataKey, ".array"));
        target = jsonData.readUint(
            string.concat(_testDataKey, ".target"));

        probe = new TestProbe();
        probe.setArray(array);
    }

    function test_allocate_and_copy_array() external {
        probe.setArray(array);
        probe.testCopyArray();
    }

    function test_more_efficient_than_Reference() external {
        uint256 referenceConsumed = probe.measureReferenceCopyArray(array);
        uint256 consumed = probe.measureCopyArray();
        assertLt(consumed, referenceConsumed, "Not More Efficient");
    }

    function test_below_the_gas_consumption_target() external {
        uint256 consumed = probe.measureCopyArray();

        assertLt(consumed, target, "Too Gas Inefficient");
    }

}