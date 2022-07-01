// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Elegy1.sol";

contract TestProbe1 {

    Elegy1 elegy1;

    constructor() {
        elegy1 = new Elegy1();
    }
    
    function test1() external {
        uint256 initialGas = gasleft();

        elegy1.setVerse(
            0x0001020304050607,
            0x101112131415161718191a1b1c1d1e1f101112131415161718191a1b1c1d1e1f,
            0x202122232425262728292A2b2c2d2e2f20212223,
            uint128(uint(0x303132333435363738393a3b3c3d3e3f)),
            uint96(uint(0x404142434445464748494a4b))
        );

        require(initialGas - gasleft() < 75000, "TOO MUCH GAS");
    }

    function test2() external {
        elegy1.setVerse(
            0x0001020304050607,
            0x101112131415161718191a1b1c1d1e1f101112131415161718191a1b1c1d1e1f,
            0x202122232425262728292A2b2c2d2e2f20212223,
            uint128(uint(0x303132333435363738393a3b3c3d3e3f)),
            uint96(uint(0x404142434445464748494a4b))
        );

        require(
            elegy1.firstVerse() == 0x0001020304050607
            && elegy1.secondVerse() == 0x101112131415161718191a1b1c1d1e1f101112131415161718191a1b1c1d1e1f
            && elegy1.thirdVerse() == 0x202122232425262728292A2b2c2d2e2f20212223
            && elegy1.fourthVerse() == uint128(uint(0x303132333435363738393a3b3c3d3e3f))
            && elegy1.fifthVerse() == uint96(uint(0x404142434445464748494a4b))
        , "INCORRECT");

        elegy1.setVerse(
            0x5051525354555657,
            0x606162636465666768696a6b6c6d6e6f606162636465666768696a6b6c6d6e6f,
            0x707172737475767778797A7b7C7D7e7F70717273,
            uint128(uint(0x808182838485868788898a8b8c8d8e8f)),
            uint96(uint(0x909192939495969798999a9b))
        );

        require(
            elegy1.firstVerse() == 0x5051525354555657
            && elegy1.secondVerse() == 0x606162636465666768696a6b6c6d6e6f606162636465666768696a6b6c6d6e6f
            && elegy1.thirdVerse() == 0x707172737475767778797A7b7C7D7e7F70717273
            && elegy1.fourthVerse() == uint128(uint(0x808182838485868788898a8b8c8d8e8f))
            && elegy1.fifthVerse() == uint96(uint(0x909192939495969798999a9b))
        , "INCORRECT");
    }

}