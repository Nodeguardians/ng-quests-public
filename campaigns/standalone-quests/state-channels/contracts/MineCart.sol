// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IMineCart.sol";

contract MineCart /* is IMineCart */ {

    constructor(
        address payable _worker1, 
        address payable _worker2,
        uint256 _timePerMove
    ) payable { }

}
