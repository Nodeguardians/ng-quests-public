// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Challenge.sol";
import "../../../contracts/test/GasMeter.sol";

abstract contract TestChallenge is Test {
    using stdJson for string;

    string jsonData;
    string keyPath;
    Challenge public challenge;

    constructor(string memory _testDataPath, string memory _keyPath) {
        jsonData = vm.readFile(_testDataPath);
        keyPath = _keyPath;

        challenge = new Challenge();
    }

    function test_boards() external {
        
        GasMeter.StoredBoard[] memory inputs = abi.decode(
            jsonData.parseRaw(keyPath),
            (GasMeter.StoredBoard[])
        );

        for (uint256 i = 0; i < inputs.length; i++) {
            challenge.recordBoard(inputs[i].id, inputs[i].board);
        }

        for (uint256 i = 0; i < inputs.length; i++) {
            string memory board = challenge.getBoard(inputs[i].id);
            bytes32 expectedHash = keccak256(abi.encode(board));
            bytes32 outputHash = keccak256(abi.encode(inputs[i].board));

            assertEq(
                outputHash,
                expectedHash,
                "Output does not match expected output"
            );
        }
    }
}


abstract contract MeasureChallenge is Test {
    using stdJson for string;

    string jsonData;
    string keyPath;
    GasMeter public gasMeter;

    constructor(string memory _testDataPath, string memory _keyPath) {
        jsonData = vm.readFile(_testDataPath);
        keyPath = _keyPath;

        gasMeter = new GasMeter();
    }

    function test_gas_efficiency(uint256 _gasLimit) internal {
        GasMeter.StoredBoard[] memory inputs = abi.decode(
            jsonData.parseRaw(keyPath),
            (GasMeter.StoredBoard[])
        );

        uint256 averageGas = gasMeter.measureGas(
            inputs
        );

        assertLt(averageGas, _gasLimit);
    }

    function test_contract_size(uint256 _maxCodeSize) internal {
        address challengeAddr = address(gasMeter.challenge());

        uint256 codeSize;
        assembly {
            codeSize := extcodesize(challengeAddr)
        }

        assertLt(codeSize, _maxCodeSize);
    }
}
