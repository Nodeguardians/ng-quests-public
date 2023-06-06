// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

// Helper library error messages
// DO NOT MODIFY THIS FILE

string constant STACK_BOUNDS_ERR = "sEVM: stack out of bounds";
string constant STACK_FULL_ERROR = "sEVM: stack is full";
string constant STACK_EMPTY_ERROR = "sEVM: stack is empty";

string constant MEMORY_BOUNDS_ERROR = "sEVM: memory out of bounds";

string constant INSUFFICIENT_BALANCE_ERROR = "sEVM: insufficient balance";
string constant READ_ONLY_ERROR = "sEVM: read only";
string constant DUPLICATE_ACCOUNT_ERROR = "sEVM: account already exists";