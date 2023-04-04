// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/test/TestProbe.sol";
import "forge-std/Test.sol";

abstract contract TestDynamicArray is Test {

    using stdJson for string;

    uint256[] refArray;

    struct ArrayAndValue { uint256[] array; uint256 value; }
    struct Inputs {
        uint256[] pop;
        ArrayAndValue popAt;
        ArrayAndValue push;
    }

    TestProbe testProbe;
    Inputs inputs;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        testProbe = new TestProbe();
        string memory jsonData = vm.readFile(_testDataPath);

        inputs = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (Inputs)
        );

    }

    function test_push() external {

        refArray = inputs.push.array;
        refArray.push(inputs.push.value);

        string memory error = testProbe
            .testPush(inputs.push.array, inputs.push.value, refArray);
        assertEq(error, "", error);
    }

    function test_pop() external {
        
        if (inputs.pop.length == 0) {
            vm.expectRevert();
            testProbe.pop(inputs.pop);
            return;
        }

        refArray = inputs.pop;
        refArray.pop();
        string memory error = testProbe.testPop(inputs.pop, refArray);
        assertEq(error, "", error);  

    }

    function test_popAt() external {

        if (inputs.popAt.value >= inputs.popAt.array.length) {
            vm.expectRevert();
            testProbe.popAt(inputs.popAt.array, inputs.popAt.value);
            return;
        }

        for (uint i = 0; i < inputs.popAt.array.length; i++) {
            if (i == inputs.popAt.value) continue;
            refArray.push(inputs.popAt.array[i]);
        }
        
        string memory error = testProbe
            .testPopAt(inputs.popAt.array, inputs.popAt.value, refArray);
        assertEq(error, "", error);  
    }

}