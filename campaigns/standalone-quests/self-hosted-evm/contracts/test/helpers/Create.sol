// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Create {

    // solc-ignore-next-line unused-param
    function create(bytes memory cdata) public payable returns (address addr) {
        assembly {
            addr := create(callvalue(), add(cdata, 0x20), mload(cdata))

            if iszero(addr) {
                returndatacopy(0, 0, returndatasize())
                revert(0, returndatasize())
            }
        }
    }
}
