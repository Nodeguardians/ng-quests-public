// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract TimeEscrow {

    /// @dev Address of recipient.
    address public recipient;
    /// @dev True if recipient has withdrawn tokens early. False otherwise.
    bool public isFullyLocked;
    /// @dev Address of ERC20 token.
    IERC20 public token;
    /// @dev Balance of tokens not withdrawn yet.
    uint256 public balance;
    /// @dev Block timestamp where tokens can be fully withdrawn afterwards.
    uint256 public endTime;

    /**
     * @dev If {endTime} has not passed, transfers {unlockedBalance()} 
     * amount of tokens to the recipient, and locks the remainder up. 
     * 
     * Otherwise, transfers all remaining tokens to the recipient. 
     */
    function withdraw() external virtual;

    /**
     * @dev Transfers all remaining tokens to creator and self destructs.
     * 
     * Fails if `msg.sender` is not creator of contract (i.e. {Summoner}).
     */
    function dispel() external virtual;

    /**
     * @dev Returns amount of tokens the recipient can withdraw early.
     *
     * Tokens are linearly unlocked over time and are 
     * fully unlocked at {endTime}. If the recipient withdraws early, 
     * all unwithdrawn tokens are locked until {endTime()}. 
     */
    function unlockedBalance() public view virtual returns (uint256); 

}
