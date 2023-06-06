// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "contracts/libraries/Memory.sol";
import "contracts/test/TestProbeMemory.sol";
import "forge-std/Test.sol";

abstract contract TestMemory is TestProbeMemory, Test {
    using MemoryLib for Memory;

    function test_StoreAndLoad() public pure {
        _testStoreAndLoad();
    }

    function test_StoreOutOfRange() public {
        vm.expectRevert("sEVM: memory out of bounds");
        _testStoreOutOfRange();
    }

    function test_Store8() public pure {
        _testStore8();
    }

    function test_Store8OutOfRange() public {
        vm.expectRevert("sEVM: memory out of bounds");
        _testStore8OutOfRange();
    }

    function test_LoadOutOfRange() public {
        vm.expectRevert("sEVM: memory out of bounds");
        _testLoadOutOfRange();
    }

    function test_Inject() public pure {
        _testInject();
    }

    function test_InjectOutOfRange() public {
        vm.expectRevert("sEVM: memory out of bounds");
        _testInjectOutOfRange();
    }

    function test_Extract() public pure {
        _testExtract();
    }

    function test_ExtractOutOfRange() public {
        vm.expectRevert("sEVM: memory out of bounds");
        _testExtractOutOfRange();
    }
}
