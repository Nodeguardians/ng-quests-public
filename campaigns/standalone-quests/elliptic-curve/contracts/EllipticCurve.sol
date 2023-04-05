// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./FieldElement.sol";

using { jacAdd, jacMul } for JacPoint global;
struct JacPoint {
    Felt x;
    Felt y;
    Felt z;
}

/**
 * @notice Adds 2 NIST P-256 points.
 * @param _P A Jacobian point to add.
 * @param _Q A Jacobian point to add.
 * @return R P + Q.
 */
function jacAdd(
    JacPoint memory _P,
    JacPoint memory _Q
) pure returns (JacPoint memory R) { }

/**
 * @notice Multiples an P-256 point with a scalar value.
 * @param _P A Jacobian point to multiply.
 * @param _k A scalar value.
 * @return Q k * P.
 */
function jacMul(
    JacPoint memory _P,
    uint256 _k
) pure returns (JacPoint memory Q) { }

/**
 * @notice Computes k * G, where G is the generator of NIST P-256.
 * @param _k A scalar value.
 * @return P k * G.
 */
function generatePoint(
    uint256 _k
) pure returns (JacPoint memory P) { }

/**
 * @notice Projects an affine point into the Jacobian space.
 * @param _x x-coordinate of the affine point.
 * @param _y y-coordinate of the affine point.
 * @return P The projected Jacobian point.
 */
function affineToJac(
    Felt _x, Felt _y
) pure returns (JacPoint memory P) { }

/**
 * @notice Converts a Jacobian point back into the affine space.
 * @param _P The Jacobian point.
 * @return x x-coordinate of the affine point.
 * @return y y-coordinate of the affine point.
 */
function jacToAffine(
    JacPoint memory _P
) pure returns (Felt x, Felt y) { }
