// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Farm1 {

    Tractor public tractor;
    uint256 public harvestedCrops;
    mapping(uint32 => uint32) public fedCows;

    constructor() {
        tractor = new Tractor();
    }

    /// @dev Can only be called by tractor
    function harvestCrops(uint256 count) external {
        require(msg.sender == address(tractor));
        harvestedCrops = count;
    }

    /// @dev Can only be called by tractor
    function feedCow(uint32 cowId, uint32 amount) external {
        require(msg.sender == address(tractor));
        fedCows[cowId] = amount;
    }

}

contract Tractor {

    function drive(
        bytes calldata _instructions, 
        address _target
    ) external {
        (bool result, ) = _target.call(_instructions);
        require(result, "Call failed");
    }

}
