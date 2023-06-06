// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "contracts/libraries/Stack.sol";
import "contracts/test/TestProbeStack.sol";
import "forge-std/Test.sol";

abstract contract TestStack is TestProbeStack, Test {
    using StackLib for Stack;

    function test_PushAndPeek() public pure {
        _testPushAndPeek();
    }

    function test_PushFullStack() public {
        vm.expectRevert("sEVM: stack is full");
        _testPushFullStack();
    }

    function test_Pop() public pure {
        _testPop();
    }

    function test_PopEmptyStack() public {
        vm.expectRevert("sEVM: stack is empty");
        _testPopEmptyStack();
    }

    function test_Swap() public pure {
        _testSwap();
    }

    function test_SwapEmptyStack() public {
        vm.expectRevert("sEVM: stack is empty");
        _testSwapEmptyStack();
    }

    function test_SwapOutOfRange() public {
        vm.expectRevert("sEVM: stack out of bounds");
        _testSwapOutOfRange();
    }

    function test_PeekEmptyStack() public {
        vm.expectRevert("sEVM: stack is empty");
        _testPeekEmptyStack();
    }

    function test_PeekOutOfRange() public {
        vm.expectRevert("sEVM: stack out of bounds");
        _testPeekOutOfRange();
    }
}
