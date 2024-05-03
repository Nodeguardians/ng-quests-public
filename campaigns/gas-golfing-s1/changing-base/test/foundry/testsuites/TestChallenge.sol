// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Challenge.sol";
import "../../../contracts/test/GasMeter.sol";

struct Input {
    string inputBase;
    string inputString;
    string name;
    string outputBase;
    string outputString;
}

abstract contract TestChallenge is Test {
    using stdJson for string;

    Challenge public challenge;
    string public jsonData;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
        challenge = new Challenge();
    }

    function test_change_of_base(string memory _key) internal {
        Input memory input = abi.decode(jsonData.parseRaw(_key), (Input));
        string memory output = challenge.transmuteBase(
            input.inputString,
            input.inputBase,
            input.outputBase
        );
        assertEq(
            keccak256(abi.encode(output)),
            keccak256(abi.encode(input.outputString))
        );
    }
}

abstract contract MeasureChallenge is Test {
    using stdJson for string;

    string public jsonData;
    GasMeter public gasMeter;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);

        gasMeter = new GasMeter();
    }

    function test_gas_efficiency(uint256 gasLimit) internal {
        
        Input[] memory inputs = abi.decode(
            jsonData.parseRaw(""), 
            (Input[])
        );

        uint256 gasConsumption = 0;
        for (uint256 i = 0; i < inputs.length; i++) {
            Input memory input = inputs[i];
            gasConsumption += gasMeter.measureGas(
                input.inputString,
                input.outputString,
                input.inputBase,
                input.outputBase
            );
        }

        uint256 averageGas = gasConsumption / inputs.length;
        assertLt(averageGas, gasLimit);
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
