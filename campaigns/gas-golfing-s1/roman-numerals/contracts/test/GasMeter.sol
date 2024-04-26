// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Challenge.sol";

contract GasMeter {

    Challenge challenge;

    constructor() {
        challenge = new Challenge();
    }

    function measureGas(
        uint256[] memory input,
        string[] memory output
    ) external view returns (uint256 gas) {
        uint256 gasConsumption = 0;
        for (uint256 i = 0; i < input.length; i++) {
            gasConsumption += measureGas(input[i], output[i]);
        }
        return gasConsumption / input.length;
    }

    function measureGas(
        uint256 input,
        string memory output
    ) internal view returns (uint256 gas) {
        uint256 initGas = gasleft();
        string memory result = challenge.romanify(input);
        gas = initGas - gasleft();

        require(
            keccak256(bytes(result)) == keccak256(bytes(output)), 
            "Unexpected result"
        );

        return gas;
    }
}
