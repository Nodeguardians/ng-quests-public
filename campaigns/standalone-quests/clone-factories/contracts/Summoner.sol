// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./SpiritCat.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract Summoner {

    /// @dev Creator of contract.
    address public owner;

    event EscrowSummoned(address escrow);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Creates a `SpiritCat` contract with the specified parameters. 
     * Only can be called by {owner}.
     * 
     * @param recipient Address of SpiritCat's recipient.
     * @param token Address of ERC20 token.
     * @param balance Initial amount of ERC20 token to be held by  escrow.
     * @param lockTime Time in seconds before recipient can 
     * fully withdraw tokens.
     */
    function summon(
        address recipient,
        IERC20 token,
        uint256 balance,
        uint256 lockTime
    ) external virtual;

    function dispel(address escrow) external virtual;

}
