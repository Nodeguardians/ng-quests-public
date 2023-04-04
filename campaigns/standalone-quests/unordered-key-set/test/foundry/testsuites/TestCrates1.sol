// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Crates.sol";

contract TestCrates1 is Test {
    
    using stdJson for string;

    struct TestCrate {
        uint256 id;
        uint256 size;
        uint256 strength; 
    }

    TestCrate[] testCrates;
    Crates crates;

    constructor(string memory _testDataPath) {
        string memory jsonData = vm.readFile(_testDataPath);

        TestCrate[] memory _testCrates = abi.decode(
            jsonData.parseRaw(".crates"),
            (TestCrate[])
        );

        for (uint i = 0; i < _testCrates.length; i++) {
            testCrates.push(_testCrates[i]);
        }

    }

    function setUp() external {
        crates = new Crates();
    }

    function test_insert_and_retrieve_crates() external {
        for (uint256 i = 0; i < testCrates.length; i++) {
            crates.insertCrate(
                testCrates[i].id,
                testCrates[i].size,
                testCrates[i].strength
            );
        }

        for (uint256 i = 0; i < testCrates.length; i++) {
            (uint256 size, uint256 strength) 
                = crates.getCrate(testCrates[i].id);

            assertEq(size, testCrates[i].size, "Unexpected Crate");
            assertEq(strength, testCrates[i].strength, "Unexpected Crate");
            
        }
    }

    function test_fail_if_inserting_an_existing_crate() external {
        TestCrate memory tc = testCrates[0];
        crates.insertCrate(tc.id, tc.size, tc.strength);

        vm.expectRevert();
        crates.insertCrate(tc.id, tc.size, tc.strength);
    }

    function test_fail_if_retrieving_an_inexistent_crate() external {
        TestCrate memory tc = testCrates[0];
        vm.expectRevert();
        crates.getCrate(tc.id);
    }

    function test_iterate_crates() external {
        for (uint256 i = 0; i < testCrates.length; i++) {
            crates.insertCrate(
                testCrates[i].id,
                testCrates[i].size,
                testCrates[i].strength
            );
        }

        uint256[] memory ids = crates.getCrateIds();
        _assertEqualIds(ids, testCrates);
        
    }

    function _assertEqualIds(
        uint256[] memory _ids,
        TestCrate[] memory _testCrates
    ) private {
        assertEq(
            _ids.length, _testCrates.length, 
            "Incorrect number of crates"
        );

        for (uint i = 0; i < _ids.length; i++) {
            bool found;
            for (uint j = 0; j < _ids.length; j++) {
                if (_ids[i] != _testCrates[j].id) { continue; }

                found = true;
                break;
            } 

            assertTrue(found, "Missing Crate"); 
        }
    }

}