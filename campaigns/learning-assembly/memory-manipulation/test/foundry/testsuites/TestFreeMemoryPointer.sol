// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/test/TestProbe.sol";
import "forge-std/Test.sol";

abstract contract TestFreeMemoryPointer is Test {

    using stdJson for string;

    struct Chunk { uint256 allocated; uint256 size; }
    TestProbe testProbe;
    string jsonData;

    constructor(string memory _testDataPath) {
        testProbe = new TestProbe();
        jsonData = vm.readFile(_testDataPath);
    }

    function test_getFreeMemoryPointer() external {
        uint256[] memory inputs = jsonData.readUintArray(".freeMemoryPointer");

        for (uint i = 0; i < inputs.length; i++) {
            string memory error = testProbe.testGetFreeMemoryPointer(inputs[i]);
            assertEq(error, "", error);
        }
    }

    function test_getMaxAccessedMemory() external {
        uint256[] memory inputs = jsonData.readUintArray(".maxAccessedMemory");

        for (uint i = 0; i < inputs.length; i++) {
            string memory error = testProbe.testGetMaxAccessedMemory(inputs[i]);
            assertEq(error, "", error);
        }
    }

    function test_allocateMemory() external {
        uint256[] memory inputs = jsonData.readUintArray(".allocateMemory");

        for (uint i = 0; i < inputs.length; i++) {
            string memory error = testProbe.testAllocateMemory(inputs[i]);
            assertEq(error, "", error);
        }
    }
    
    function test_freeMemory() external {
        
        Chunk[] memory chunks = abi.decode(
            jsonData.parseRaw(".freeMemory"),
            (Chunk[])
        );

        for (uint i = 0; i < chunks.length; i++) {
            if (chunks[i].size > chunks[i].allocated) {
                vm.expectRevert();
            }

        
            string memory error = testProbe.testFreeMemory(chunks[i].allocated, chunks[i].size);
            assertEq(error, "", error);
        }

    }

}