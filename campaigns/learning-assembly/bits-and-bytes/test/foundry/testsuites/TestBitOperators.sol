// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/BitOperators.sol";
import "forge-std/Test.sol";

abstract contract TestBitOperators is Test {

    BitOperators bitOperators;

    using stdJson for string;

    struct UPair { uint256 x; uint256 y; }
    struct Inputs {
        UPair clearBit;
        UPair flipBit;
        UPair getBit;
        UPair setBit;
        UPair shiftLeft;
    }

    Inputs inputs;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        bitOperators = new BitOperators();

        string memory jsonData = vm.readFile(_testDataPath);
        
        inputs = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (Inputs)
        );

    }

    function test_shiftLeft() external {
        UPair memory p = inputs.shiftLeft;
        uint256 result = bitOperators.shiftLeft(p.x, p.y);
        assertEq(result, p.x << p.y, "Unexpected Result");
    }

    function test_setBit() external {
        UPair memory p = inputs.setBit;
        uint256 expected = p.x | (1 << p.y);
        uint256 result = bitOperators.setBit(p.x, p.y);
        assertEq(result, expected, "Unexpected Result");
    }

    function test_clearBit() external {
        UPair memory p = inputs.clearBit;

        uint256 expected = p.x & ~(1 << p.y);
        uint256 result = bitOperators.clearBit(p.x, p.y);
        assertEq(result, expected, "Unexpected Result");
    }

    function test_flipBit() external {
        UPair memory p = inputs.flipBit;

        uint256 expected = p.x ^ (1 << p.y);
        uint256 result = bitOperators.flipBit(p.x, p.y);
        assertEq(result, expected, "Unexpected Result");
    }

    function test_getBit() external {
        UPair memory p = inputs.getBit;
        uint256 expected = (p.x >> p.y) & 1;
        uint256 result = bitOperators.getBit(p.x, p.y);
        assertEq(expected, result, "Bad Power");
    }

}