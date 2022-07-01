// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract BadMechSuit1 {
    
    address constant ADMIN = 0xda5db8cd87955F8A552D4fd0Ce1DB9E168e10632;
    address private impl;

    constructor() {
        impl = address(new SuitLogic());
    }

    /// @dev You can assume this fallback function works safely!
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

    function upgradeTo(address _impl) public {
        require(msg.sender == ADMIN);
        impl = _impl;
    }

}

contract SuitLogic {

    bytes32 private DO_NOT_USE;
    int32 private fuel;
    
    constructor() {
        fuel = type(int32).max;
    }

    function throwFists() external view returns (bytes32) {
        require(fuel >= 0);
        return keccak256("WHAMM!");
    }

}