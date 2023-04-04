// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Challenge.sol";
import "../Reference.sol";

contract GasMeter is Challenge, Reference {

    constructor(uint _skip) Challenge(_skip) Reference(_skip) { }

    function measureGas(
        uint256[] calldata _inputArray
    ) external view returns (uint256 gas) {
        uint256 initGas = gasleft();
        sumAllExceptSkip(_inputArray);
        return initGas - gasleft();
    }

    function measureReferenceGas(
        uint256[] calldata _inputArray
    ) external view returns (uint256 gas) {
        uint256 initGas = gasleft();
        referenceSumAllExceptSkip(_inputArray);
        return initGas - gasleft();
    }

}
