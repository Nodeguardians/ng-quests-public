 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestGreatScribe.sol";
import "../../contracts/GreatArchives.sol";

contract PublicTest1 is TestGreatScribe {

    string PATH = "test/data/greatScribe.json";
    constructor() TestGreatScribe(_archives(), _archives(), PATH) { }

    function _archives() private returns (address) {
        return address(new GreatArchives());
    }

}
