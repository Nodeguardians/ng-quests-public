// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Account.sol";
import "./Stack.sol";
import "./Memory.sol";

struct Scope {
    // EVM execution context
    Context context;

    // Contract being executed
    Contract _contract;

    // EVM API
    API api;

    // EVM execution state

    // STOP flag
    bool stop;

    // Program counter : position in the bytecode
    uint256 pc;

    // Stack
    Stack stack;

    // Memory
    Memory _memory;

    // Read-only flag
    bool readOnly;

    // Call states

    // REVERTED flag
    bool reverted;

    // Return data buffer
    bytes returndata;
}

struct Contract {
    // Contract address
    address self;

    // Contract bytecode
    bytes bytecode;
}

struct Context {

    // msg.sender
    address caller;

    // tx.origin
    address origin;

    // recipient
    address to;

    // msg.value
    uint256 callvalue;

    // msg.data
    bytes _calldata;
}

struct API {
     // Accounts & storage API
    function (address) view returns (Account memory) getAccount;
    function (address) view returns (uint256) getAccountBalance;
    function (address) view returns (uint256) getAccountNonce;
    function (address) view returns (bytes memory) getAccountBytecode;
    function (address, bytes memory) setAccountBytecode;
    function (address, bytes32) view returns (bytes32) readAccountStorageAt;
    function (address, bytes32, bytes32) writeAccountStorageAt;
    function (address, address, uint256) transfer;
}

