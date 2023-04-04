// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Crates.sol";

contract TestCrates2 is Test {
    
    using stdJson for string;

    struct TestCrate {
        uint256 id;
        uint256 size;
        uint256 strength; 
    }

    TestCrate[] testCrates;
    uint256[] deleteIds;
    uint256 gasPerInsert;
    uint256 gasPerDelete;
    uint256 gasToIterate;

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

        deleteIds = jsonData.readUintArray(".deleteIds");
        gasPerInsert = jsonData.readUint(".gasPerInsert");
        gasPerDelete = jsonData.readUint(".gasPerDelete");
        gasToIterate = jsonData.readUint(".gasToIterate");

        crates = new Crates();
    }

    function test_delete_crates() external {
        for (uint256 i = 0; i < testCrates.length; i++) {
            crates.insertCrate(
                testCrates[i].id,
                testCrates[i].size,
                testCrates[i].strength
            );
        }

        for (uint256 i = 0; i < deleteIds.length; i++) {
            crates.deleteCrate(deleteIds[i]);
            vm.expectRevert();
            crates.getCrate(deleteIds[i]);
        }
    }

    function test_be_gas_efficient() external {

        for (uint256 i = 0; i < testCrates.length; i++) {
            crates.insertCrate{ gas: gasPerInsert }(
                testCrates[i].id,
                testCrates[i].size,
                testCrates[i].strength
            );
        }

        for (uint256 i = 0; i < deleteIds.length; i++) {
            crates.deleteCrate{ gas: gasPerDelete }(deleteIds[i]);
        }

        crates.getCrateIds{ gas: gasToIterate }();

    }

    function test_fail_if_deleting_an_inexistent_crate() external {
        Crates crates1 = new Crates();
        crates1.insertCrate(
            testCrates[0].id, 
            testCrates[0].size,
            testCrates[0].strength
        );

        vm.expectRevert();
        crates1.getCrate(testCrates[1].id);
    }

    function test_do_not_interate_deleted_crates() external {
        for (uint256 i = 0; i < testCrates.length; i++) {
            crates.insertCrate(
                testCrates[i].id,
                testCrates[i].size,
                testCrates[i].strength
            );
        }

        for (uint256 i = 0; i < deleteIds.length; i++) {
            crates.deleteCrate(deleteIds[i]);
        }

        _assertEqualIds(
            crates.getCrateIds(),
            testCrates,
            deleteIds
        );
    }

    function _assertEqualIds(
        uint256[] memory _ids,
        TestCrate[] memory _testCrates,
        uint256[] memory _excluding
    ) private {
        assertEq(
            _ids.length, _testCrates.length - _excluding.length, 
            "Incorrect number of crates"
        );

        for (uint i = 0; i < _ids.length; i++) {
            bool excluded;
            for (uint j = 0; j < _excluding.length; j++) {
                if (_ids[i] == _excluding[j]) { 
                    excluded = true;
                    break; 
                }
            }
            if (excluded) { break; }

            bool found;
            for (uint j = 0; j < _testCrates.length; j++) {
                if (_ids[i] == _testCrates[j].id) {
                    found = true;
                    break;
                }
            } 

            assertTrue(found, "Missing Crate"); 
        }
    }

}