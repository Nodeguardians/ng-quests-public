// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {
    /**
     * @dev Change a number from inputBase to outputBase
     * @param input The input number represented as a string in inputBase
     * @param inputBase The base of the input number
     * @param outputBase The base of the output number
     * @return output The input number represented as a string in outputBase
     */
    function transmuteBase(
        string calldata input,
        string calldata inputBase,
        string calldata outputBase
    ) public pure returns (string memory output) { }

}
