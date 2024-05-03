// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Challenge.sol";

contract GasMeter {

    Challenge public challenge;

    constructor() {
        challenge = new Challenge();
    }

    function measureGas(
        string calldata input,
        string calldata output,
        string calldata inputBase,
        string calldata outputBase
    ) external view returns (uint256 gas) {
        uint256 initGas = gasleft();
        string memory result = challenge.transmuteBase(
            input, 
            inputBase, 
            outputBase
        );
        gas = initGas - gasleft();

        require(
            keccak256(bytes(result)) == keccak256(bytes(output)), 
            "Unexpected result"
        );
    }
}
