// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestTree.sol";

contract PublicTest1 is TestTree {

    string DATA_PATH = "test/data/proofs.json";
    string DATA_KEY = "[0]";
    constructor() TestTree(DATA_PATH, DATA_KEY) { }

}

contract PublicTest2 is TestTree {

    string DATA_PATH = "test/data/proofs.json";
    string DATA_KEY = "[1]";
    constructor() TestTree(DATA_PATH, DATA_KEY) { }

}