// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev To be deployed on Ethereum Sepolia
contract LuteMaker2 {

    address immutable public user;
    bool public woodGiven;

    constructor(address _user) {
        user = _user;
    }

    /// @dev `_wood` must be obtained from `L2LonelyHill`!
    function giveSingingWood(bytes32 _wood) external {
        require(msg.sender == user, "Not authorized");

        // "???" is placeholder for actual secret value
        require(
            _wood == "???",
            "Wrong wood, it's not singing at all!"
        );

        woodGiven = true;
    }
}
