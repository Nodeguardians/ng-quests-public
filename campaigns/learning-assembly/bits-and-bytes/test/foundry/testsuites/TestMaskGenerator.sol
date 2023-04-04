// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/MaskGenerator.sol";
import "forge-std/Test.sol";

abstract contract TestMaskGenerator is Test {

    MaskGenerator maskGenerator;

    using stdJson for string;
    struct Input {
        uint256 at;
        uint256 expectedMask;
        uint256 nBytes;
        bool reversed;
    }

    Input input;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        maskGenerator = new MaskGenerator();
        string memory jsonData = vm.readFile(_testDataPath);
        
        input = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (Input)
        );
    }

    function test_generateMask() external {

        if (input.nBytes + input.at > 32) {
            vm.expectRevert();
        }
        uint256 result = maskGenerator.generateMask(
            input.nBytes, 
            input.at,
            input.reversed
        );

        if (input.nBytes + input.at <= 32) {
            assertEq(result, input.expectedMask, "Unexpected Result");
        }
    }

}