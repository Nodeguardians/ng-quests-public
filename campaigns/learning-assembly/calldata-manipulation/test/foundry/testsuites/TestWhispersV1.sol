// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/WhispersV1.sol";
import "forge-std/Test.sol";

abstract contract TestWhispersV1 is Test {

    using stdJson for string;

    WhispersV1 whispers;
    uint256[] uintValues;
    string[] strValues;

    constructor(string memory _testDataPath) {
        whispers = new WhispersV1();

        string memory jsonData = vm.readFile(_testDataPath);
        
        uintValues = jsonData.readUintArray(".uintValues");
        strValues = jsonData.readStringArray(".strValues");

    }

    function test_whisperUint256() external {
        for (uint i = 0; i < uintValues.length; i++) {

            bytes memory _calldata = abi.encodeWithSelector(
                WhispersV1.whisperUint256.selector, 
                uintValues[i]
            );

            (bool success, bytes memory data) = address(whispers).call(_calldata);
            assertTrue(success, "Whispers call failed");

            uint256 result = abi.decode(data, (uint256));
            assertEq(result, uintValues[i], "Unexpected Result");
        }
    }

    function test_whisperString() external {
        for (uint i = 0; i < strValues.length; i++) {

            bytes memory _calldata = abi.encodeWithSelector(
                WhispersV1.whisperString.selector, 
                strValues[i]
            );

            (bool success, bytes memory data) = address(whispers).call(_calldata);
            assertTrue(success, "Whispers call failed");

            bytes32 expectedHash = keccak256(abi.encode(strValues[i]));
            assertEq(keccak256(data), expectedHash, "Unexpected Result");
        }
    }

}