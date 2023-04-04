// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";

contract GoudaGoblin {

    IERC20 public gold;
    IERC20 public gouda;
    address public liquidityPool;

    uint256 public lockedGouda = 10000 ether;

    constructor(
        IERC20 _gouda,
        IERC20 _gold,
        IUniswapV2Factory _uniswap
    ) {
        gouda = _gouda;
        gold = _gold;
        liquidityPool = _uniswap.getPair(address(_gouda), address(_gold));
    }

    function giveGouda() external {
        
        require(
            fetchGoudaPrice() <= 10 gwei, 
            "The goblins will not give away expensive gouda!"
        );

        gouda.transfer(msg.sender, lockedGouda);
        lockedGouda = 0;
    }

    /// @dev Fetches the current gouda price (in gold) from uniswap, with 9 decimals of precision.
    function fetchGoudaPrice() public view returns (uint goudaPrice) {

        uint goldBalance = gold.balanceOf(liquidityPool);
        uint goudaBalance = gouda.balanceOf(liquidityPool);

        goudaPrice = goldBalance * 1 gwei / goudaBalance;

    }

}