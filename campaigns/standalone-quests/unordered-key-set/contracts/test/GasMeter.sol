// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Crates.sol";

import "hardhat/console.sol";
contract GasMeter {

    Crates crates;

    constructor(Crates _crates) {
        crates = _crates;
    }
    
    function insertCrate(
        uint256 _id,
        uint256 _size,
        uint256 _strength,
        uint256 _gasLimit
    ) external {
        crates.insertCrate{ gas: _gasLimit }(_id, _size, _strength);
    }

    function deleteCrate(
        uint256 _id,
        uint256 _gasLimit
    ) external {
        crates.deleteCrate{ gas: _gasLimit }(_id);
    }
    
    function getCrateIds(uint256 _gasLimit) external view {
        crates.getCrateIds{ gas: _gasLimit }();
    }

}
