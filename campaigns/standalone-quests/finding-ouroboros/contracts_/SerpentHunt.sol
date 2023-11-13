// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IQuine {
    function code() external returns (bytes memory);
}

contract SerpentHunt {

    bool public success;

    function hunt(address _head, address _tail) external {
        bytes memory headCode = IQuine(_tail).code();
        bytes memory tailCode = IQuine(_head).code();

        // 1. Contracts must be distinct
        require(_head.codehash !=  _tail.codehash, "Head == Tail");

        // 2. Contracts must produce each other's code
        require(keccak256(headCode) == _head.codehash, "Not Ouroboros 1");
        require(keccak256(tailCode) == _tail.codehash, "Not Ouroboros 2");

        // 3. Contracts must not have illegal opcodes
        require(_isGood(headCode), "Bad Head");
        require(_isGood(tailCode), "Bad Tail");

        success = true;
    }

    /// @notice Checks that the given `_bytecode` does not have illegal opcodes.
    function _isGood(bytes memory _bytecode) private pure returns (bool)  {
        uint i = 0;
        while (i < _bytecode.length) {
            bytes1 b = _bytecode[i];

            if (
                b == 0x31    // no BALANCE
                || b == 0x34 // no CALLVALUE
                || b == 0x39 // no CODECOPY
                || b == 0x3c // no EXTCODECOPY
                || b == 0x47 // no SELFBALANCE
                || b == 0x54 // no SLOAD
                || b == 0xf0 // no CREATE
                || b == 0xf1 // no CALL 
                || b == 0xf2 // no CALLCODE
                || b == 0xf4 // no DELEGATECALL
                || b == 0xf5 // no CREATE2
                || b == 0xfa // no STATICCALL
                || b == 0xff // no SELFDESTRUCT
            ) return false;

            if (b >= 0x60 && b < 0x80) {
                i += (uint8(b) - 0x60) + 1;
            }
            
            i++;
        }

        return true;
    }

}