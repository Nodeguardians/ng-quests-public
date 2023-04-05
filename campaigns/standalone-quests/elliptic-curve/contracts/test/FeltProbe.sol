// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../FieldElement.sol";

contract FeltProbe {

    uint256 constant P = 0xffffffff00000001000000000000000000000000ffffffffffffffffffffffff;

    function testAdd(
        Felt _x, 
        Felt _y
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();
        Felt sum = add(_x, _y);
        gas = initGas - gasleft(); 

        require(
            addmod(Felt.unwrap(_x), Felt.unwrap(_y), P) == Felt.unwrap(sum),
            "Result Incorrect"
        );
    }

    function testSub(
        Felt _x, 
        Felt _y
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();
        Felt diff = sub(_x, _y);
        gas =  initGas - gasleft(); 

        require(
            addmod(Felt.unwrap(diff), Felt.unwrap(_y), P) == Felt.unwrap(_x),
            "Result Incorrect"
        );
    }

    function testMul(
        Felt _x, 
        Felt _y
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();
        Felt prod = mul(_x, _y);
        gas = initGas - gasleft(); 

        require(
            mulmod(Felt.unwrap(_x), Felt.unwrap(_y), P) == Felt.unwrap(prod),
            "Result Incorrect"
        );

    }

    function testEq(
        Felt _x, 
        Felt _y
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();
        bool isEquals = equals(_x, _y);
        gas =  initGas - gasleft(); 

        require(
            isEquals == (Felt.unwrap(_x) == Felt.unwrap(_y)),
            "Result incorrect"
        );
    }

    function testInv(
        Felt _x
    ) external view returns (uint256 gas) {
        uint initGas = gasleft();
        Felt xInv = inv(_x);
        gas = initGas - gasleft(); 

        require(
            mulmod(Felt.unwrap(_x), Felt.unwrap(xInv), P) == 1,
            "Result Incorrect"
        );
    }
    
}