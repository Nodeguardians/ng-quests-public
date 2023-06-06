// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

struct Memory {
    // The maximum offset that has been written to.
    uint256 max;
    // The memory as a byte array.
    bytes mem;
}

library MemoryLib {

    /**
     * @dev Initializes a new virtual stack.
     * @param maxSize Maximum size of memory.
     * @return memory A new instance of memory.
     */
    function init(uint256 maxSize) internal pure returns (Memory memory) {
        // CODE HERE
    }

    /**
     * @dev Stores the given 32 bytes value at the given offset in virtual memory.
     * @notice Should revert if the offset is out of bounds.
     * @param mem The memory to write to.
     * @param offset The offset to write at.
     * @param value The value to write.
     */
    function store(
        Memory memory mem,
        uint256 offset,
        bytes32 value
    ) internal pure {
        // CODE HERE
    }

    /**
     * @dev Stores the given 1 byte value at the given offset in virtual memory.
     * @notice Should revert if the offset is out of bounds.
     * @param mem The memory to write to.
     * @param offset The offset to write at.
     * @param value The value to write.
     */
    function store8(
        Memory memory mem,
        uint256 offset,
        uint8 value
    ) internal pure {
        // CODE HERE
    }

    /**
     * @dev Returns the 32 bytes value at the given offset in virtual memory.
     * @notice Should revert if the offset is out of bounds.
     * @param mem The memory to read from.
     * @param offset The offset to read at.
     * @return value The value at the given offset.
     */
    function load(
        Memory memory mem,
        uint256 offset
    ) internal pure returns (bytes32 value) {
        // CODE HERE
    }

    /**
     * @dev Copies a given length of bytes from real memory to virtual memory.
     * @notice Should revert if the dst (+ length) is out of bounds.
     * @param mem The memory to copy into.
     * @param src The source offset in real memory.
     * @param dst The destination offset in virtual memory.
     * @param length The length of bytes to copy.
     */
    function inject(
        Memory memory mem,
        uint256 src,
        uint256 dst,
        uint256 length
    ) internal pure {
        // CODE HERE
    }

    /**
     * @dev Extracts a byte array from virtual memory to real memory.
     * @notice Should revert if the offset ( + length ) is out of bounds.
     * @param mem The memory object.
     * @param offset The offset in virtual memory.
     * @param length The length of the byte array.
     * @return buffer The byte array extracted.
     */
    function extract(
        Memory memory mem,
        uint256 offset,
        uint256 length
    ) internal pure returns (bytes memory buffer) {
        // CODE HERE
    }
}
