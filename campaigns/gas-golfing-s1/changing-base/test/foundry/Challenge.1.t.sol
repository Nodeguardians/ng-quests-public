// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestChallenge.sol";

contract PublicTest1 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";

    constructor() TestChallenge(DATA_PATH) {}

    function test_decimal_to_binary() external {
        test_change_of_base("[0]");
    }

    function test_binary_to_decimal() external {
        test_change_of_base("[1]");
    }

}

contract PublicTest2 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";

    constructor() TestChallenge(DATA_PATH) {}

    function test_decimal_to_hexadecimal() external {
        test_change_of_base("[2]");
    }

    function test_hexadecimal_to_decimal() external {
        test_change_of_base("[3]");
    }

}

contract PublicTest3 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";

    constructor() TestChallenge(DATA_PATH) {}

    function test_custom_base_to_decimal() external {
        test_change_of_base("[4]");
    }

    function test_hexadecimal_to_custom_base() external {
        test_change_of_base("[5]");
    }

}

contract PublicTest4 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";

    constructor() TestChallenge(DATA_PATH) {}

    function test_custom_base_to_binary() external {
        test_change_of_base("[6]");
    }

}

contract GasEfficiencyTest is MeasureChallenge {
    string DATA_PATH = "test/data/moreInputs.json";
    constructor() MeasureChallenge(DATA_PATH) {}

    function test_gas_efficiency() external {
        test_gas_efficiency(50000);
    }

    function test_compact_contract_size() external {
        test_contract_size(2000);
    }
}