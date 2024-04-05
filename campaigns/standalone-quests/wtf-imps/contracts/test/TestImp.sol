/////
// RULE: This file is for test purposees.
//       No modifying this file!
/////

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Imp } from "../Imp.sol";

contract TestImp {

    function villager() external pure returns (Imp.Target) {
        return Imp.Target.Villager;
    }

    function self() external pure returns (Imp.Target) {
        return Imp.Target.Self;
    }

}