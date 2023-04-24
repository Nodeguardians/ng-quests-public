// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../FieldElement.sol";
import "../EllipticCurve.sol";

contract CurveProbe {

    Felt constant FELT_ZERO = Felt.wrap(0);
    Felt constant FELT_ONE = Felt.wrap(1);

    /////
    // PART 2 TESTS
    ////
    
    function testAdd(
        JacPoint memory _P, 
        JacPoint memory _Q,
        JacPoint memory _R
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();

        JacPoint memory actualR = jacAdd(_P, _Q);
        gas = initGas - gasleft(); 

        require(_isEqual(actualR, _R), "Incorrect Result");

    }

    function testMul(
        uint256 _k,
        JacPoint memory _P, 
        JacPoint memory _Q
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();

        JacPoint memory actualQ = jacMul(_P, _k);
        gas = initGas - gasleft(); 

        require(_isEqual(actualQ, _Q), "Incorrect Result");
    }

    function testGen(
        uint256 _k, 
        JacPoint memory _P
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();

        JacPoint memory actualP = generatePoint(_k);
        gas = initGas - gasleft(); 

        require(_isEqual(actualP, _P), "Incorrect Result");
    }

    /////
    // PART 3 TESTS
    ////

    function testAffineToJac(
        Felt _x, 
        Felt _y
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();

        JacPoint memory P = affineToJac(_x, _y);
        gas = initGas - gasleft();

        require(_isEqual(P, _x, _y), "Incorrect Result");
    }

    function testJacToAffine(
        JacPoint memory P
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();

        (Felt x, Felt y) = jacToAffine(P);
        gas = initGas - gasleft(); 

        require(_isEqual(P, x, y), "Incorrect Result");
    }

    /////
    // HELPER FUNCTIONS
    ////

    function _isEqual(
        JacPoint memory _actual, 
        JacPoint memory _expected // z-coordinate must be 0 or 1
    ) internal pure returns (bool) {

        if (_expected.z == FELT_ZERO) {
            // _expected is point of infinity
            return _actual.z == FELT_ZERO; 
        }

        require(_expected.z == FELT_ONE, "UNEXPECTED TEST INPUT");

        return (_actual.x == _expected.x * _actual.z * _actual.z
            && _actual.y == _expected.y * _actual.z * _actual.z * _actual.z);
    }

    function _isEqual(
        JacPoint memory _JacPoint, 
        Felt _affineX,
        Felt _affineY
    ) internal pure returns (bool) {

        if (_affineX == FELT_ZERO && _affineY == FELT_ZERO) {
            // Affine point is point of infinity
            return _JacPoint.z == FELT_ZERO;
        } else if (_JacPoint.z == FELT_ZERO) {
            return false;
        }

        return (_JacPoint.x == _affineX * _JacPoint.z * _JacPoint.z
            && _JacPoint.y == _affineY * _JacPoint.z * _JacPoint.z * _JacPoint.z);
    }

}