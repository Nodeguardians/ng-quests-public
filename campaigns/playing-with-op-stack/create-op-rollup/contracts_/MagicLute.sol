// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MagicLute {

    address public immutable owner;

    // The instrument needs rollup sorcery...
    address public optimismPortal;

    constructor(address _owner) {
        owner = _owner;
    }

    function registerOptimismPortal(
        address _optimismPortal
    ) external {
        require(
            msg.sender == owner,
            "Only owner can register the optimism portal"
        );

        optimismPortal = _optimismPortal;
    }

}
