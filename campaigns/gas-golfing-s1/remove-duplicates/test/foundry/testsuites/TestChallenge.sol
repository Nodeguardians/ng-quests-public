// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Challenge.sol";
import "../../../contracts/test/GasMeter.sol";

struct Input {
    uint8[] expected;
    uint8[] input;
}

abstract contract TestChallenge is Test {
    using stdJson for string;

    Challenge public challenge;

    Input input;

    constructor(string memory _testDataPath, string memory _keyPath) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(
            jsonData.parseRaw(_keyPath),
            (Input)
        );

        challenge = new Challenge();
    }

    function test_remove_duplicates() external {
        uint8[] memory output = challenge.dispelDuplicates(
            input.input
        );

        assertEq(
            keccak256(abi.encode(output)),
            keccak256(abi.encode(input.expected))
        );
    }
}


abstract contract MeasureChallenge is Test {
    using stdJson for string;

    string jsonData;
    GasMeter public gasMeter;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);

        gasMeter = new GasMeter();
    }

    function test_gas_efficiency(uint256 _gasLimit) internal {
        Input[] memory inputs = abi.decode(
            jsonData.parseRaw(""),
            (Input[])
        );

        uint256 gasConsumption = 0;
        for (uint256 i = 0; i < inputs.length; i++) {
            Input memory input = inputs[i];
            gasConsumption += gasMeter.measureGas(
                input.input,
                input.expected
            );
        }

        uint256 averageGas = gasConsumption / inputs.length;
        assertLt(averageGas, _gasLimit);
    }
}
