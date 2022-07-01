// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract BadMechSuit2 {
    
    address private impl;

    constructor() {
        impl = address(new SuitLogicV1());
        SuitLogicV1(impl).initialize();
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

    function upgrade() external {
        impl = address(new SuitLogicV2());
    }

}

contract SuitLogicV1 {

    bytes32 DO_NOT_USE;
    uint32 ammunition;
    uint32 fuel;

    function initialize() external {
        ammunition = 8;
        fuel = 100; 
    }

    function fireCrossbow(uint times) external returns (bytes32) {
        ammunition -= uint32(times);
        return keccak256("pew! pew! pew!");
    }

}

contract SuitLogicV2 {

    bytes32 DO_NOT_USE;
    uint32 fuel;

    function swingSword() external view returns (bytes32) {
        require (fuel > 0);
        return keccak256("SHING, SHING");
    }

}