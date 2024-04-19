// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Challenge.sol";

contract GasMeter {

    Challenge challenge;

    constructor() {
        challenge = new Challenge();
    }

    function measureGas(
        uint8[] calldata input,
        uint8[] calldata output
    ) external view returns (uint256 gas) {
        uint256 initGas = gasleft();
        uint8[] memory result = challenge.dispelDuplicates(input);
        gas = initGas - gasleft();

        require(
            keccak256(abi.encodePacked(result)) == keccak256(abi.encodePacked(output)), 
            "Unexpected result"
        );
    }
}
