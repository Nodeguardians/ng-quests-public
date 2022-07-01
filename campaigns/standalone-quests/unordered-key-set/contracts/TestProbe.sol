// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SpiderEggs.sol";

/// For testing purposes
contract TestProbe {
    uint256[] private ids;
    uint256[] private sizes;
    uint256[] private strengths;

    event iteratedIds(uint256[] ids);

    constructor(
        uint256[] memory _ids,
        uint256[] memory _sizes,
        uint256[] memory _strengths
    ) {
        require(_ids.length == _sizes.length);
        require(_ids.length == _strengths.length);

        ids = _ids;
        sizes = _sizes;
        strengths = _strengths;
    }

    /// Insert and Retrieve Eggs
    function test1() external {
        SpiderEggs target = new SpiderEggs();

        uint256 initialGas = gasleft();

        for (uint256 i = 0; i < ids.length; i++) {
            target.insertEgg(ids[i], sizes[i], strengths[i]);
        }

        require(initialGas - gasleft() < 150000 * ids.length, "TOO MUCH GAS");

        for (uint256 i = 0; i < ids.length; i++) {
            (uint256 size, uint256 strength) = target.getEgg(ids[i]);

            require(size == sizes[i] && strength == strengths[i], "INCORRECT");
        }
    }

    /// Insertion should fail for an existent egg
    function test2() external {
        SpiderEggs target = new SpiderEggs();

        target.insertEgg(ids[0], sizes[0], strengths[0]);
        try target.insertEgg(ids[0], sizes[0], strengths[0]) {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }
    }

    /// Retrieval should fail for an inexistent egg
    function test3() external {
        SpiderEggs target = new SpiderEggs();

        try target.getEgg(ids[0]) {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }

        target.insertEgg(ids[1], sizes[1], strengths[1]);

        try target.getEgg(ids[2]) {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }
    }

    /// Iterate eggs
    function test4() external {
        SpiderEggs target = new SpiderEggs();

        for (uint256 i = 0; i < ids.length; i++) {
            target.insertEgg(ids[i], sizes[i], strengths[i]);
        }

        uint256 initialGas = gasleft();

        emit iteratedIds(target.getEggIds());

        require(initialGas - gasleft() < 65000, "TOO MUCH GAS");
    }

    /// Delete egg
    function test5() external {
        SpiderEggs target = new SpiderEggs();

        for (uint256 i = 0; i < ids.length; i++) {
            target.insertEgg(ids[i], sizes[i], strengths[i]);
        }

        uint256 initialGas = gasleft();
        target.deleteEgg(ids[0]);
        require(initialGas - gasleft() < 7000, "TOO MUCH GAS");

        (uint256 size, uint256 strength) = target.getEgg(ids[1]);
        require(size == sizes[1] && strength == strengths[1], "INCORRECT");

        try target.getEgg(ids[0]) {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }
    }

    function test6() external {
        SpiderEggs target = new SpiderEggs();

        target.insertEgg(ids[1], sizes[1], strengths[1]);

        try target.deleteEgg(ids[2]) {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }
    }

    function test7() external {
        SpiderEggs target = new SpiderEggs();

        for (uint256 i = 0; i < ids.length; i++) {
            target.insertEgg(ids[i], sizes[i], strengths[i]);
            target.insertEgg(ids[i] + 1, sizes[i], strengths[i]);
        }

        for (uint256 i = 0; i < ids.length; i++) {
            target.deleteEgg(ids[i] + 1);
        }

        uint256 initialGas = gasleft();

        emit iteratedIds(target.getEggIds());

        require(initialGas - gasleft() < 65000, "TOO MUCH GAS");
    }
}
