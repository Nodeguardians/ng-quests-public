// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TradingData
 * @notice Contract which holds important cross-chain data.
 */
contract TradingData is Ownable {

    /// @dev List of addresses trusted to verify cross-chain calls.
    mapping(address => bool) public isTrademaster;
    
    /// @dev Address of TradingBoat in other chains.
    mapping(uint64 => address) public tradingBoatByChainId;

    /// @dev Add new trademasters.
    /// @notice Only callable by contract's owner.
    function setTrademasters(
        address[] calldata _newMasters
    ) external onlyOwner {

        for (uint256 i; i < _newMasters.length; i++) {
            isTrademaster[_newMasters[i]] = true;
        }

    }

    /// @dev Register a new TradingBoat contract from a given chain.
    function registerBoat(
        uint64 _chainId,
        address _boatAddress
    ) external {
        require(isTrademaster[msg.sender], "Only trademasters can register new boats");
        tradingBoatByChainId[_chainId] = _boatAddress;
    }

}
