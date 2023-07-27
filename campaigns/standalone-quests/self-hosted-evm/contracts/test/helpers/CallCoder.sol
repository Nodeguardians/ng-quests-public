// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Callee.sol";

contract CallCoder {
    uint256 public value;
    Callee callee;

    constructor(Callee _callee) {
        callee = _callee;
    }

    function callCode(bytes memory cdata
    // solc-ignore-next-line unused-param
    ) public returns (bytes memory) {
        address calleeAddr = address(callee);

        assembly {
            let success := callcode(
                5000, // gas
                calleeAddr, // target address
                callvalue(), // value
                add(cdata, 0x20), // input addr
                mload(cdata), // input size
                0, // output addr
                0x00 // output size
            ) 

            let size := returndatasize()
            returndatacopy(0, 0, size)

            switch success
            case 0 {
                revert(0, size)
            }
            default {
                return(0, size)
            }
        }
    }
}
