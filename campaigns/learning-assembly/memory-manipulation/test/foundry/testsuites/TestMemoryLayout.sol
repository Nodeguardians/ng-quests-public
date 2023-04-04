// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/test/TestProbe.sol";
import "forge-std/Test.sol";

abstract contract TestMemoryLayout is Test {

    using stdJson for string;

    struct Array { uint256 size; uint256 value; }

    TestProbe testProbe;
    string jsonData;
    string testDataKey;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        testProbe = new TestProbe();
        jsonData = vm.readFile(_testDataPath);
        testDataKey = _testDataKey;
    }

    function test_createUint256Array() external {
        string memory key = string.concat(testDataKey, ".createUint256Array");
        Array memory array = abi.decode(
            jsonData.parseRaw(key),
            (Array)
        );

        string memory error = testProbe
            .testCreateUint256Array(array.size, array.value);
        assertEq(error, "", error);
    }

    function test_createBytesArray() external {
        string memory key = string.concat(testDataKey, ".createBytesArray");
        Array memory array = abi.decode(
            jsonData.parseRaw(key),
            (Array)
        );

        string memory error = testProbe
            .testCreateBytesArray(array.size, bytes1(bytes32(array.value)));
        assertEq(error, "", error);  
    }

}