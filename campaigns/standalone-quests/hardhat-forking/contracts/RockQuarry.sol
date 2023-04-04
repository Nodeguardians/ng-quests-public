// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./QuarryBase.sol";

contract RockQuarry is QuarryBase {

    address public constant owner = 0xD23d39ffF7E391e62D464cd5eF09e52ed58bc889;

    function dig() external view returns (string memory treasure) {

        require(msg.sender == owner, "Caller must be owner");
        
        return super._dig();
    }

}