// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Loot {

    // The thief owns the loot...
    address public owner = 0x7D0673F244c9C2e890fd294E1c65a51Fc7359963;

    // Take back the loot!
    function transfer(address _newOwner) public {
        require(msg.sender == owner, "Hands off my loot!");
        owner = _newOwner;
    }

}