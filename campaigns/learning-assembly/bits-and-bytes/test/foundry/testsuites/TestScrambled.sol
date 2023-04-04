// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Scrambled.sol";
import "forge-std/Test.sol";

abstract contract TestScrambled is Test {
    using stdJson for string;

    struct Input {
        bytes32 scrambled;
        address unscrambled;
    }
    Input input;
    Scrambled scrambled;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        scrambled = new Scrambled();

        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (Input)
        );
    }

    function test_recoverAddress() external {
        address result = scrambled.recoverAddress(input.scrambled);

        assertEq(result, input.unscrambled, "Unexpected Result");
    }


}