 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestMulticall.sol";
import "../../contracts/GreaterArchives.sol";

contract PublicTest1 is TestMulticall {

    string PATH = "test/data/multicall.json";
    constructor() TestMulticall(_archives(), _archives(), PATH) { }

    function _archives() private returns (address) {
        return address(new GreaterArchives());
    }

}
