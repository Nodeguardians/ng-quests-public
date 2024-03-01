// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

abstract contract Imp {

    enum Target { Villager, Self }

    function attack() external virtual returns (Target);

}