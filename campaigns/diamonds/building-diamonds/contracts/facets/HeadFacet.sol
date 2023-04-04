// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @dev For testing purposes
contract HeadFacet {
    
    uint256 immutable private salt;

    constructor(uint256 _salt) {
        salt = _salt;
    }

    function func1() external view returns (uint256) { return salt; }

    function func2() external view returns (uint256) { return salt; }

    function func3() external view returns (uint256) { return salt; }

    function func4() external view returns (uint256) { return salt; }

    function func5() external view returns (uint256) { return salt; }

}