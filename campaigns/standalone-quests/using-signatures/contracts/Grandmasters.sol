// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IGrandmasters.sol";

contract Grandmasters is IGrandmasters {

    mapping(address => bool) public override grandmasters;

    constructor() payable { }

    function acceptInvite(bytes calldata signature) external override { }

    function receiveBlessing(uint256 amount, bytes calldata signature) external override { }

}