// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract UndeadHorde {

    address public constant LADY_WHITEFROST 
        = 0x0DEaD582fa84de81e5287132d70d9a296224Cf90;

    mapping(address => bool) public infested;

    function infestDead(address _target) external {
        require(_fromLady(), "We only answer to our Queen Mother...");
        require(_isDead(_target), "Target is still alive...");

        infested[_target] = true;
    }

    function releaseArmy() external {
        require(_fromLady(), "We only answer to our Queen Mother...");
        selfdestruct(payable(LADY_WHITEFROST));
    }

    function _fromLady() private view returns (bool) {
        return msg.sender == LADY_WHITEFROST;
    }

    function _isDead(address _target) private pure returns (bool) {
        uint160 prefix = uint160(_target) >> 140;
        return prefix == 0x0dead;
    }

}