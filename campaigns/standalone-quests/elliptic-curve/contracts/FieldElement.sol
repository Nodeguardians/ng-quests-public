// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

type Felt is uint256;
using { 
    add as +, 
    sub as -, 
    mul as *, 
    equals as ==, 
    inv 
} for Felt global;

/// @notice Returns x + y (mod p).
/// @dev p is the prime of NIST P-256 curve.
function add(
    Felt x, 
    Felt y
) pure returns (Felt z) { }

/// @notice Returns x - y (mod p).
/// @dev p is the prime of NIST P-256 curve.
function sub(
    Felt x, 
    Felt y
) pure returns (Felt z) { }

/// @notice Returns x * y (mod p).
/// @dev p is the prime of NIST P-256 curve.
function mul(
    Felt x, 
    Felt y
) pure returns (Felt z) { }

/// @notice Returns true if x = y (mod p), and false otherwise.
/// @dev p is the prime of NIST P-256 curve.
function equals(
    Felt x, 
    Felt y
) pure returns (bool isEqual) { }

/// @notice Returns the modular inverse of x, where x * y = 1 (mod p).
/// @dev p is the prime of NIST P-256 curve.
function inv(
    Felt _x
) pure returns (Felt y) { }

