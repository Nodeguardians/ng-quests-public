// SPDX-License-Identifier: MIT

import "./ISimpleGameV2.sol";

pragma solidity ^0.8.9;

// MODIFY CODE
contract SimpleGameV2 is ISimpleGameV2 {
    bool public isFinished;
    uint256 lastDepositedBlock;

    function totalDeposit() external view returns (uint256) {
        return address(this).balance;
    }

    function deposit() public payable override {
        require(msg.value == 0.1 ether, "Must deposit 0.1 Ether");
        require(!isFinished, "The game is over");
        require(
            lastDepositedBlock != block.number,
            "Only can deposit once per block"
        );

        lastDepositedBlock = block.number;
    }

    function claim() public override {
        require(address(this).balance >= 1 ether, "Condition not satisfied");

        payable(msg.sender).transfer(address(this).balance);
        isFinished = true;
    }
}
