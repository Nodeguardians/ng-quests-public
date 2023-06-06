// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

struct Stack {
    uint256 depth;
    bytes32[] stack;
}

library StackLib {

    /**
     * @dev Initializes a new virtual stack.
     * @param maxDepth Maximum depth of the stack.
     * @return stack A new empty stack.
     */
    function init(uint256 maxDepth) internal pure returns (Stack memory) {
        // CODE HERE
    }

    /**
     * @dev Returns the value at the given depth.
     * @notice Should revert if the stack is empty.
     * @notice Should revert if the depth is out of bounds.
     * @param stack The stack to peek into.
     * @param depth The depth to peek at.
     * @return value The value at the given depth.
     */
    function peek(
        Stack memory stack,
        uint256 depth
    ) internal pure returns (bytes32) {
        // CODE HERE
    }

    /**
     * @dev Returns the value at the top of the stack.
     * @notice Should revert if the stack is empty.
     * @param stack The stack to pop from.
     * @return value The value at the top of the stack.
     */
    function pop(
        Stack memory stack
    ) internal pure returns (bytes32) {
        // CODE HERE
    }

    /**
     * @dev Pushes the given value to the top of the stack.
     * @notice Should revert if the stack is full
     * @param stack The stack to push to.
     * @param value The value to push to the top of the stack.
     */
    function push(Stack memory stack, bytes32 value) internal pure {
        // CODE HERE
    }

    /**
     * @dev Swaps the value at the top of the stack with the value at the given depth.
     * @notice Should revert if the stack is empty.
     * @notice Should revert if the depth is out of bounds.
     * @param stack The stack to swap in.
     * @param depth The depth to swap with the top of the stack.
     */
    function swap(
        Stack memory stack,
        uint256 depth
    ) internal pure {
        // CODE HERE
    }
}
