// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/SafeMath.sol";

abstract contract TestSafeMath is Test {

    SafeMath safeMath;

    using stdJson for string;

    struct Pair {
        bool shouldOverflow;
        int256 x;
        int256 y;
    }
    struct Inputs {
        Pair add;
        Pair div;
        Pair mul;
        Pair sub;
    }
    Inputs inputs;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);
        inputs = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (Inputs)
        );

        safeMath = new SafeMath();
    }

    function test_add() external {
        if (inputs.add.shouldOverflow) {
            vm.expectRevert();
            safeMath.add(inputs.add.x, inputs.add.y);   
        } else {
            int256 result = safeMath.add(inputs.add.x, inputs.add.y);
            assertEq(result, inputs.add.x + inputs.add.y, "Unexpected Result");
        }
    }

    function test_subtract() external {
        if (inputs.sub.shouldOverflow) {
            vm.expectRevert();
            safeMath.sub(inputs.sub.x, inputs.sub.y);   
        } else {
            int256 result = safeMath.sub(inputs.sub.x, inputs.sub.y);
            assertEq(result, inputs.sub.x - inputs.sub.y, "Unexpected Result");
        }
    }

    function test_multiply() external {
        if (inputs.mul.shouldOverflow) {
            vm.expectRevert();
            safeMath.mul(inputs.mul.x, inputs.mul.y);   
        } else {
            int256 result = safeMath.mul(inputs.mul.x, inputs.mul.y);
            assertEq(result, inputs.mul.x * inputs.mul.y, "Unexpected Result");
        }
    }

    function test_divide() external {
        if (inputs.div.shouldOverflow) {
            vm.expectRevert();
            safeMath.div(inputs.div.x, inputs.div.y);   
        } else {
            int256 result = safeMath.div(inputs.div.x, inputs.div.y);
            assertEq(result, inputs.div.x / inputs.div.y, "Unexpected Result");
        }
    }
}