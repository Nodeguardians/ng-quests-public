// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract GreatArchives {

    struct Record {
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

    function recordHistory(uint256 index, bytes calldata data) public returns (bytes memory) {
        return _writeRecord(historyRecords, index, data);
    }

    function recordMagic(uint256 index, bytes calldata data) public returns (bytes memory) {
        return _writeRecord(magicRecords, index, data);
    }

    function writeScience(address id, bytes calldata data) public returns (bool) {
        return _writeScroll(scienceScrolls, id, data);
    }

    function writeMusic(address id, bytes calldata data) public returns (bool) {
        return _writeScroll(musicScrolls, id, data);
    }

    /**
     * @dev Writes `data` to `records[index]`. 
     * If record already exists, just return old existent data instead. 
     */
    function _writeRecord(
        Record[] storage records,
        uint256 index,
        bytes calldata data
    ) private returns (bytes memory) {

        bytes memory oldData = records[index].data;
        if (oldData.length > 0) { return oldData; }

        records[index] = Record(block.timestamp, data);
        return data;

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
