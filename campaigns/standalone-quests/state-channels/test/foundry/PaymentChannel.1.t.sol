// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestPaymentChannel.sol";

contract PublicTest1 is TestPaymentChannel {
    string PATH = "test/data/paymentChannel.json";
    string KEY = "[0]";
    constructor() TestPaymentChannel(PATH, KEY) { } 
}

contract PublicTest2 is TestPaymentChannel {
    string PATH = "test/data/paymentChannel.json";
    string KEY = "[1]";
    constructor() TestPaymentChannel(PATH, KEY) { } 
}

contract PublicTest3 is TestPaymentChannel {
    string PATH = "test/data/paymentChannel.json";
    string KEY = "[2]";
    constructor() TestPaymentChannel(PATH, KEY) { } 
}