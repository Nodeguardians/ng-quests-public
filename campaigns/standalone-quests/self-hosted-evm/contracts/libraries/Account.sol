// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

struct Account {
    address self;
    bytes bytecode;
    uint256 balance;
    uint256 nonce;
}
