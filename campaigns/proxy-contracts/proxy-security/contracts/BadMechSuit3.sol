// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract BadMechSuit3 {
    
    address public impl;

    constructor() {
        impl = address(new SuitLogic());
        SuitLogic(impl).initialize();
    }

    /// @dev You can safely assume this fallback function works safely!
    fallback() external {
        address _impl = impl;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

}

contract SuitLogic {

    bytes32 private DO_NOT_USE;
    uint32 private fuel;

    function initialize() external {
        fuel = 100;
    }

    function shootFire() external pure returns (bytes32) {
        return keccak256("FWOOOOOSH");
    }

    function explode() external payable {
        if (msg.value > fuel * 100 ether) {
            selfdestruct(payable(msg.sender));
        }
    }

}