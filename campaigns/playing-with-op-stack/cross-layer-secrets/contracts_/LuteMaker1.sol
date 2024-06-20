// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev To be deployed on Ethereum Sepolia
contract LuteMaker1 {

    address immutable public user;
    bool public hairGiven;

    constructor(address _user) {
        user = _user;
    }

    /// @dev `_hair` must be obtained from `L2MaidenCoast`!
    function giveHarpyHair(bytes32 _hair) external {
        require(msg.sender == user, "Not authorized");
        
        // "???" is placeholder for actual secret value
        require(
            _hair == "???",
            "Wrong hairs, are you sure it's from a harpy?"
        );

        hairGiven = true;
    }

}
