// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Arithmetic.sol";
import "forge-std/Test.sol";

abstract contract TestArithmetic is Test {

    Arithmetic arithmetic;

    using stdJson for string;

    struct UPair { uint256 x; uint256 y; }
    struct Pair { int256 x; int256 y; }
    struct Inputs {
        Pair addition;
        UPair modulo;
        Pair multiplication;
        UPair power;
        Pair signedDivision;
    }

    Inputs inputs;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        arithmetic = new Arithmetic();

        string memory jsonData = vm.readFile(_testDataPath);
        
        inputs = abi.decode(
            jsonData.parseRaw(_testDataKey),
            (Inputs)
        );

    }

    function test_add() external {
        Pair memory p = inputs.addition;
        int256 sum = arithmetic.addition(p.x, p.y);
        assertEq(sum, p.x + p.y, "Bad Addition");
    }

    function test_multiply() external {
        Pair memory p = inputs.multiplication;
        int256 product = arithmetic.multiplication(p.x, p.y);
        assertEq(product, p.x * p.y, "Bad Multiplication");
    }

    function test_signed_divide() external {
        Pair memory p = inputs.signedDivision;
        int256 quotient = arithmetic.signedDivision(p.x, p.y);
        assertEq(quotient, p.x / p.y, "Bad Division");
    }

    function test_modulo() external {
        UPair memory p = inputs.modulo;
        uint256 rem = arithmetic.modulo(p.x, p.y);
        assertEq(rem, p.x % p.y, "Bad remainder");
    }

    function test_exponentiate_power() external {
        UPair memory p = inputs.power;
        uint256 power = arithmetic.power(p.x, p.y);
        assertEq(power, p.x ** p.y, "Bad Power");
    }

}