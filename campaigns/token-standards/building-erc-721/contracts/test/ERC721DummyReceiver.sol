// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IAmuletPouch.sol";

/// @dev For testing purposes
contract ERC721DummyReceiver {

    bool paused;
    bytes public data;
    function pause() external {
        paused = true;
    }

    function onERC721Received(
        address, 
        address, 
        uint256, 
        bytes calldata _data
    ) external returns (bytes4) {
        if (!paused) {
            data = _data;
            return this.onERC721Received.selector;
        } else {
            return 0x12345678;
        }

    }
}