/////
// RULE: No modifying this file!
/////

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Imp  } from "./Imp.sol";

contract TrickyImp is Imp {

    function attack() external pure override returns (Target) {
        return Target.Villager;
    }

}
