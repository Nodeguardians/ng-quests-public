// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Challenge.sol";
import "../../../contracts/test/GasMeter.sol";

abstract contract TestChallenge is Test {

    using stdJson for string;

    struct Input {
        uint256[] decimal;
        string[] roman;
    }
    
    Input input;
    Challenge challenge;

    constructor(string memory _testDataPath, string memory _keyPath) {
        string memory jsonData = vm.readFile(_testDataPath);

        input = abi.decode(
            jsonData.parseRaw(_keyPath),
            (Input)
        );

        challenge = new Challenge();
    }
    
    function test_romanify() external {
        for (uint256 i = 0; i < input.decimal.length; i++) {
            string memory output = challenge.romanify(input.decimal[i]);
            assertEq(output, input.roman[i]);
        }
    }

}

abstract contract MeasureChallenge is Test {

    using stdJson for string;

    struct Input {
        uint256[] decimal;
        string[] roman;
    }
    
    string jsonData;
    GasMeter gasMeter;

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
                input.decimal,
                input.roman
            );
        }

        uint256 averageGas = gasConsumption / inputs.length;
        assertLt(averageGas, _gasLimit);
    }

}