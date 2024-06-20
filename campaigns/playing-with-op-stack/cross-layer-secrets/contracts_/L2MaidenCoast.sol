// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/// @dev Deployed on OP Sepolia
contract L2MaidenCoast {

    IERC721 public coastalMaps;

    constructor(IERC721 _coastalMaps) {
        coastalMaps = _coastalMaps;
    }

    /// @dev Returns the hair of a harpy, represented as a secret bytes32 hash.
    /// The caller must have a Coastal Map (on L2).
    function getHarpyHair() external view returns (bytes32) {
        require(
            coastalMaps.balanceOf(msg.sender) > 0, 
            "You do not have a coastal map!"
        );
        
        // "???" is placeholder for actual secret value
        return "???";
    }

}
