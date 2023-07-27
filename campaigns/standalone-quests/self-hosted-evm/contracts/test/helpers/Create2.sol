// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Create2 {
    // solc-ignore-next-line unused-param
    function create2(
        bytes memory cdata,
        uint256 salt
    ) public payable returns (address addr) {
        assembly {
            addr := create2(callvalue(), add(cdata, 0x20), mload(cdata), salt)

            if iszero(addr) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
    }
}
