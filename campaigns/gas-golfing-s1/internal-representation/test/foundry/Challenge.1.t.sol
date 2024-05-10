// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestChallenge.sol";

string constant DATA_PATH = "test/data/inputs.json";

contract PublicTest1 is TestChallenge {
    string KEY_PATH = "[0]";

    constructor() TestChallenge(DATA_PATH, KEY_PATH) {}
}

contract PublicTest2 is TestChallenge {
    string KEY_PATH = "[1]";

    constructor() TestChallenge(DATA_PATH, KEY_PATH) {}
}

contract PublicTest3 is TestChallenge {
    string KEY_PATH = "[2]";

    constructor() TestChallenge(DATA_PATH, KEY_PATH) {}
}

contract GasEfficiencyTest is MeasureChallenge {
    string KEY_PATH = "[2]";

    constructor() MeasureChallenge(DATA_PATH, KEY_PATH) {}

    function test_gas_efficiency() external {
        test_gas_efficiency(220000);
    }

    function test_compact_contract_size() external {
        test_contract_size(4000);
    }
}