// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IVillageVoting.sol";

contract VillageVoting /* is IVillageVoting */ {

    constructor(
        address[] memory _villagers,
        uint256[] memory _tokenBalances,
        uint256[] memory _proposalIds
    ) { 
        // ...
    }

}
