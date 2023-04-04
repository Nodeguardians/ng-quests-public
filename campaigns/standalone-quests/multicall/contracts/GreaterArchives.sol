// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Multicall.sol";

contract GreaterArchives is Multicall {

    struct Record {
        address author; // A new attribute!
        uint256 timestamp;
        bytes data;
    }

    /**
     * Read Functions
     */

    Record[] public historyRecords;
    Record[] public magicRecords;

    mapping(address => bytes) public scienceScrolls;
    mapping(address => bytes) public musicScrolls;

    /**
     * Write Functions
     */

    function recordHistory(bytes calldata data) public {
        historyRecords.push(
            Record(msg.sender, block.timestamp, data)
        );
    }

    function recordMagic(bytes calldata data) public {
        magicRecords.push(
            Record(msg.sender, block.timestamp, data)
        );
    }

    function writeScience(address id, bytes calldata data) public returns (bool) {
        return _writeScroll(scienceScrolls, id, data);
    }

    function writeMusic(address id, bytes calldata data) public returns (bool) {
        return _writeScroll(musicScrolls, id, data);
    }

    /**
     * @dev Writes `data` to `scrolls[id]` and return true. 
     * If record already exists, just return false.
     */
    function _writeScroll(
        mapping(address => bytes) storage scrolls,
        address id,
        bytes calldata data
    ) private returns (bool) {

        if (scrolls[id].length > 0) { return false; }

        scrolls[id] = data;
        return true;

    }

}
