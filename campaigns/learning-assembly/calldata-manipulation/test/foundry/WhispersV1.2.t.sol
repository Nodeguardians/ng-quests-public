// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestWhispersV1.sol";

contract PublicTest1 is TestWhispersV1 {

    string PATH = "test/data/whispersV1.json";
    constructor() TestWhispersV1(PATH) { }

}