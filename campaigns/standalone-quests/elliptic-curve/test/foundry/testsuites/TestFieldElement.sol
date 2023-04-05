// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/test/FeltProbe.sol";

abstract contract TestFelt is Test {
    
    using stdJson for string;

    struct FeltPair { Felt x; Felt y; }

    string jsonData;
    string testDataKey;

    FeltProbe feltProbe;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        jsonData = vm.readFile(_testDataPath);
        testDataKey = _testDataKey;
        feltProbe = new FeltProbe();
    }

    function test_modulo_add() external {
        string memory key = string.concat(testDataKey, ".addTests");
        FeltPair[] memory addTests = abi.decode(
            jsonData.parseRaw(key),
            (FeltPair[])
        );
        for (uint i = 0; i < addTests.length; i++) {
            FeltPair memory pair = addTests[i];
            uint256 gas = feltProbe.testAdd(pair.x, pair.y);

            assertLt(gas, 120, "Too gas inefficient");
        }
    }

    function test_modulo_subtract() external {
        string memory key = string.concat(testDataKey, ".subTests");
        FeltPair[] memory subTests = abi.decode(
            jsonData.parseRaw(key),
            (FeltPair[])
        );
        for (uint i = 0; i < subTests.length; i++) {
            FeltPair memory pair =  subTests[i];
            uint256 gas = feltProbe.testSub(pair.x, pair.y);

            assertLt(gas, 160, "Too gas inefficient");
        }
    }

    function test_modulo_multiply() external {
        string memory key = string.concat(testDataKey, ".mulTests");
        FeltPair[] memory mulTests = abi.decode(
            jsonData.parseRaw(key),
            (FeltPair[])
        );
        for (uint i = 0; i < mulTests.length; i++) {
            FeltPair memory pair =  mulTests[i];
            uint256 gas = feltProbe.testMul(pair.x, pair.y);

            assertLt(gas, 120, "Too gas inefficient");
        }
    }

    function test_check_equality() external {
        string memory key = string.concat(testDataKey, ".eqTests");
        FeltPair[] memory eqTests = abi.decode(
            jsonData.parseRaw(key),
            (FeltPair[])
        );
        for (uint i = 0; i < eqTests.length; i++) {
            FeltPair memory pair =  eqTests[i];
            uint256 gas = feltProbe.testEq(pair.x, pair.y);

            assertLt(gas, 30, "Too gas inefficient");
        }
    }

    function test_calculate_inverse() external {
        string memory key = string.concat(testDataKey, ".invTests");
        Felt[] memory invTests = abi.decode(
            jsonData.parseRaw(key),
            (Felt[])
        );
        for (uint i = 0; i < invTests.length; i++) {
            uint256 gas = feltProbe.testInv(invTests[i]);

            assertLt(gas, 100000, "Too gas inefficient");
        }
    }

}
