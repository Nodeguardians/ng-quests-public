// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/WhispersV2.sol";
import "forge-std/Test.sol";

abstract contract TestWhispersV2 is Test {

    using stdJson for string;

    WhispersV2 whispers;
    uint256[] uncompressed;
    bytes compressed;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        whispers = new WhispersV2();
        
        if (bytes(_testDataPath).length == 0) {
            return;
        }

        string memory jsonData = vm.readFile(_testDataPath);
        uncompressed = jsonData.readUintArray(
            string.concat(_testDataKey, ".uncompressed")
        );
        
        compressed = jsonData.readBytes(
            string.concat(_testDataKey, ".compressed")
        ); 
        
    }

    function test_uncompress_whisper() external {
        
        bytes memory _calldata = bytes.concat(
            abi.encodePacked(WhispersV2.compressedWhisper.selector), 
            compressed
        );

        (bool success, bytes memory data) = address(whispers).call(_calldata);
        assertTrue(success, "Whispers call failed");

        uint256[] memory result = abi.decode(data, (uint256[]));

        assertEq(result, uncompressed, "Unexpected Result");
        
    }

}