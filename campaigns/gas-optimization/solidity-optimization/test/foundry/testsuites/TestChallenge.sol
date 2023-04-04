// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Challenge.sol";
import "../../../contracts/Reference.sol";
import "../../../contracts/test/GasMeter.sol";
import "forge-std/Test.sol";

abstract contract TestSumAllExceptSkip is Test {

    using stdJson for string;

    uint256[] array;
    uint256 target;
    uint256 expectedSum;

    Challenge challenge;
    Reference ref;
    GasMeter meter;

    constructor(
        string memory _testDataPath,
        string memory _key
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        
        array = jsonData.readUintArray(
            string.concat(_key, ".array"));
        uint256 skipValue = jsonData.readUint(
            string.concat(_key, ".skip"));
        target = jsonData.readUint(
            string.concat(_key, ".target"));

        challenge = new Challenge(skipValue);
        ref = new Reference(skipValue);
        meter = new GasMeter(skipValue);
        expectedSum = ref.referenceSumAllExceptSkip(array);
    }

    function test_correctly_compute_sum() external {
        uint256 actualSum = challenge.sumAllExceptSkip(array);

        assertEq(expectedSum, actualSum, "Incorrect Result");
    }

    function test_more_efficient_than_Reference() external {

        uint256 consumed = meter.measureGas(array);
        uint256 refConsumed = meter.measureReferenceGas(array);

        assertLt(consumed, refConsumed, "Not More Efficient");
    }

    function test_below_the_gas_consumption_target() external {
        uint256 consumed = meter.measureGas(array);

        assertLt(consumed, target, "Too Gas Inefficient");
    }

}

abstract contract TestSumAllExceptSkipOverflow is Test {

    using stdJson for string;
    uint256[] array;

    Challenge challenge;

    constructor(
        string memory _testDataPath,
        string memory _key
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        
        array = jsonData.readUintArray(
            string.concat(_key, ".array"));
        uint256 skipValue = jsonData.readUint(
            string.concat(_key, ".skip"));

        challenge = new Challenge(skipValue);
    }

    function test_revert_on_overflow() external {
        vm.expectRevert();
        challenge.sumAllExceptSkip(array);
    }

}
