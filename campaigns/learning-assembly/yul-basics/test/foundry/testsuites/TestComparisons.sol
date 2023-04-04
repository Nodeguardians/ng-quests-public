// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Comparisons.sol";

abstract contract TestComparisons is Test {

    Comparisons comparisons;

    using stdJson for string;

    struct UPair { uint256 x; uint256 y; }
    struct Pair { int256 x; int256 y; }
    struct Triplet { int256 x; int256 y; int256 z; }

    string jsonData;

    constructor(string memory _testDataPath) {
        comparisons = new Comparisons();

        jsonData = vm.readFile(_testDataPath);
    }

    function test_isZero() external {
        int256[] memory inputs = abi.decode(
            jsonData.parseRaw(".isZero"),
            (int256[])
        );
        for (uint i = 0; i < inputs.length; i++) {
            int256 x = inputs[i];
            bool result = comparisons.isZero(x);

            assertEq(result, x == 0, "Unexpected Result");
        }
    }

    function test_greaterThan() external {
        UPair[] memory inputs = abi.decode(
            jsonData.parseRaw(".greaterThan"),
            (UPair[])
        );
        for (uint i = 0; i < inputs.length; i++) {
            UPair memory p = inputs[i];
            bool result = comparisons.greaterThan(p.x, p.y);

            assertEq(result, p.x > p.y, "Unexpected Result");
        }
    }

    function test_signedLowerThan() external {
        Pair[] memory inputs = abi.decode(
            jsonData.parseRaw(".signedLowerThan"),
            (Pair[])
        );
        for (uint i = 0; i < inputs.length; i++) {
            Pair memory p = inputs[i];
            bool result = comparisons.signedLowerThan(p.x, p.y);

            assertEq(result, p.x < p.y, "Unexpected Result");
        }
    }

    function test_isNegativeOrEqualTen() external {
        int256[] memory inputs = abi.decode(
            jsonData.parseRaw(".isNegativeOrEqualTen"),
            (int256[])
        );
        for (uint i = 0; i < inputs.length; i++) {
            int256 x =inputs[i];
            bool result = comparisons.isNegativeOrEqualTen(x);

            assertEq(result, x < 0 || x == 10, "Unexpected Result");
        }
    }

    function test_isInRange() external {
        Triplet[] memory inputs = abi.decode(
            jsonData.parseRaw(".isInRange"),
            (Triplet[])
        );
        for (uint i = 0; i < inputs.length; i++) {
            Triplet memory t = inputs[i];
            bool result = comparisons.isInRange(t.x, t.y, t.z);

            assertEq(result, t.x >= t.y && t.x <= t.z, "Unexpected Result");
        }
    }
}