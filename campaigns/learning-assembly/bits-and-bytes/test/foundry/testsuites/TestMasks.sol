// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Masks.sol";
import "forge-std/Test.sol";

abstract contract TestMasks is Test {

    Masks masks;

    using stdJson for string;

    string jsonData;
    string testDataKey;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        masks = new Masks();
        jsonData = vm.readFile(_testDataPath);
        testDataKey = _testDataKey;
    }

    function test_setMask() external {
        (uint256 value, uint256 mask, uint256 expected) = _getInput(
            ".setMask", ".value", ".mask", ".expected"
        );

        uint256 result = masks.setMask(value, mask);

        assertEq(result, expected, "Unexpected Result");
    }

    function test_clearMask() external {
        (uint256 value, uint256 mask, uint256 expected) = _getInput(
            ".clearMask", ".value", ".mask", ".expected"
        );

        uint256 result = masks.clearMask(value, mask);

        assertEq(result, expected, "Unexpected Result");
    }

    function test_get8BytesAt() external {
        (uint256 value, uint256 at, uint256 expected) = _getInput(
            ".get8BytesAt", ".value", ".at", ".expected"
        );
        uint256 result = masks.get8BytesAt(value, at);

        assertEq(result, expected, "Unexpected Result");
    }

    function _getInput(
        string memory _test, 
        string memory _key1,
        string memory _key2,
        string memory _key3
    ) private returns(uint256, uint256, uint256) {
        string memory key1 = string.concat(testDataKey, _test, _key1);
        uint256 value1 = jsonData.readUint(key1);

        string memory key2 = string.concat(testDataKey, _test, _key2);
        uint256 value2 = jsonData.readUint(key2);

        string memory key3 = string.concat(testDataKey, _test, _key3);
        uint256 value3 = jsonData.readUint(key3);
            
        return (value1, value2, value3);
    }
}