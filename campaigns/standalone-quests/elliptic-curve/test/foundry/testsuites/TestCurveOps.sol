// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/test/CurveProbe.sol";

abstract contract TestCurveOps is Test {

    using stdJson for string;

    struct PointPairTest {
        JacPoint P;
        JacPoint Q;
        JacPoint R;
    }
    struct PointAndScalarTest {
        JacPoint P;
        JacPoint Q;
        uint256 k;
    }
    struct ScalarTest {
        JacPoint P;
        uint256 k;
    }

    string jsonData;
    string testDataKey;

    CurveProbe curveProbe;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        jsonData = vm.readFile(_testDataPath);
        testDataKey = _testDataKey;
        curveProbe = new CurveProbe();
    }

    function test_add_unique_points() external {
        string memory key = string.concat(testDataKey, ".addTests");
        PointPairTest[] memory addTests = abi.decode(
            jsonData.parseRaw(key),
            (PointPairTest[])
        );

        for (uint i = 0; i < addTests.length; i++) {
            PointPairTest memory input = addTests[i];
            uint256 gas = curveProbe.testAdd(input.P, input.Q, input.R);
            assertLt(gas, 3000, "Too gas inefficient");
        }
    }

    function test_double_identical_points() external {
        string memory key = string.concat(testDataKey, ".doubleTests");
        PointPairTest[] memory doubleTests = abi.decode(
            jsonData.parseRaw(key),
            (PointPairTest[])
        );

        for (uint i = 0; i < doubleTests.length; i++) {
            PointPairTest memory input = doubleTests[i];
            uint256 gas = curveProbe.testAdd(input.P, input.Q, input.R);

            assertLt(gas, 3400, "Too gas inefficient");
        }
    }

    function test_multiply_points() external {
        string memory key = string.concat(testDataKey, ".mulTests");
        PointAndScalarTest[] memory mulTests = abi.decode(
            jsonData.parseRaw(key),
            (PointAndScalarTest[])
        );

        for (uint i = 0; i < mulTests.length; i++) {
            PointAndScalarTest memory input = mulTests[i];
            uint256 gas = curveProbe.testMul(input.k, input.P, input.Q);

            assertLt(gas, 1200000, "Too gas inefficient");
        }
    }

    function test_generate_points() external{
        string memory key = string.concat(testDataKey, ".genTests");
        ScalarTest[] memory genTests = abi.decode(
            jsonData.parseRaw(key),
            (ScalarTest[])
        );

        for (uint i = 0; i < genTests.length; i++) {
            ScalarTest memory input = genTests[i];
            uint256 gas = curveProbe.testGen(input.k, input.P);

            assertLt(gas, 1200000, "Too gas inefficient");
        }
    }

}
