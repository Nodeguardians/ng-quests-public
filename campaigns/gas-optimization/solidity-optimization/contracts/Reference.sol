// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Reference {

    // You should skip any item equal to SKIP in your sum
    uint256 SKIP;

    constructor(uint256 skip) {
        SKIP = skip;
    }

    /**
     * @notice Returns the sum of the elements of the given array, skipping any SKIP value.
     * @param array The array to sum.
     * @return sum The sum of all the elements of the array excluding SKIP.
     */
    function referenceSumAllExceptSkip(
        uint256[] memory array
    ) public view returns (uint256 sum) {

        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] != SKIP) {
                sum += array[i];
            }
        }

        return sum;

    }

}
