// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "../libraries/Stack.sol";

bytes32 constant ONE = bytes32(uint256(1));
bytes32 constant TWO = bytes32(uint256(2));

contract TestProbeStack {
    using StackLib for Stack;

    function _testPushAndPeek() public pure {
        Stack memory stack = StackLib.init(2);
        stack.push(ONE);
        stack.push(TWO);

        require(stack.peek(0) == TWO, "invalid stack value");
        require(stack.peek(1) == ONE, "invalid stack value");
    }

    function _testPushFullStack() public pure {
        Stack memory stack = StackLib.init(2);
        stack.push(ONE);
        stack.push(TWO); // Will not revert if earlier _testPushAndPeek passes
        stack.push(TWO); // Should revert

        revert("stack pushed to full stack");
    }

    function _testPop() public pure {
        Stack memory stack = StackLib.init(10);
        stack.push(ONE);
        stack.push(TWO);
        bytes32 value = stack.pop();

        require(value == TWO, "invalid stack value");
    }

    function _testPopEmptyStack() public pure {
        Stack memory stack = StackLib.init(10);
        stack.pop();

        revert("stack popped from empty stack");
    }

    function _testSwap() public pure {
        Stack memory stack = StackLib.init(10);
        stack.push(ONE);
        stack.push(TWO);
        stack.swap(1);

        require(stack.peek(0) == ONE, "invalid stack value");
        require(stack.peek(1) == TWO, "invalid stack value");
    }

    function _testSwapEmptyStack() public pure {
        Stack memory stack = StackLib.init(10);
        stack.swap(0);

        revert("stack swapped from empty stack");
    }

    function _testSwapOutOfRange() public pure {
        Stack memory stack = StackLib.init(10);
        stack.push(ONE);
        stack.swap(1);

        revert("stack swapped out of range");
    }

    function _testPeekEmptyStack() public pure {
        Stack memory stack = StackLib.init(10);
        stack.peek(0);

        revert("stack peeked from empty stack");
    }

    function _testPeekOutOfRange() public pure {
        Stack memory stack = StackLib.init(10);
        stack.push(ONE);
        stack.peek(1);

        revert("stack peeked out of range");
    }
}
