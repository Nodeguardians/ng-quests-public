// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// MODIFY CODE
contract SimpleGameV2 {
    bool public isFinished;
    uint256 lastDepositedBlock;

    function totalDeposit() external view returns (uint256) {
        return address(this).balance;
    }

    function deposit() public payable {
        require(msg.value == 0.1 ether, "Must deposit 0.1 Ether");
        require(!isFinished, "The game is over");
        require(
            lastDepositedBlock != block.number,
            "Only can deposit once per block"
        );

        lastDepositedBlock = block.number;
    }

    function claim() public {
        require(address(this).balance >= 1 ether, "Condition not satisfied");

        payable(msg.sender).transfer(address(this).balance);
        isFinished = true;
    }
}
