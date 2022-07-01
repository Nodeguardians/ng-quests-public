// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Elegy2.sol";

contract TestProbe2 {

    Elegy2 elegy2;

    event gasUsed(uint256);
    constructor(uint32[] memory testData) {
        elegy2 = new Elegy2(testData);
    }

    // Test functionality and gas cost
    function test1(
        uint[] calldata nonces,
        uint[] calldata gasLimits, 
        uint[] calldata expectedSums
    ) external {

        for (uint i = 0; i < nonces.length; i++) {
            uint256 initialGas = gasleft();
            elegy2.play(nonces[i]);
            require(initialGas - gasleft() < gasLimits[i], "TOO MUCH GAS");
            require(elegy2.totalSum() == expectedSums[i], "INCORRECT");
        }
    }

    // Tests that totalSum is a public variable (and not a function)
    function test2() external view {
        uint256 initialGas = gasleft();
        elegy2.totalSum();
        require(initialGas - gasleft() < 10000, "INCORRECT");
    }

}