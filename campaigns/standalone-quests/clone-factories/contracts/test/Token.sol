// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    uint constant _initial_supply = 100 ether;

    constructor(address owner) ERC20("Test Token", "TKN") {
        _mint(owner, _initial_supply);
    }

}