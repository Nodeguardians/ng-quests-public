// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./QuarryBase.sol";

contract EmeraldQuarry is QuarryBase {

    uint256 constant UNLOCKED_TIME = 4817832457;

    function dig() external view returns (string memory treasure) {

        require(block.timestamp > UNLOCKED_TIME, "Quarry not unlocked yet");

        return super._dig();
    }

}