// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestChallenge.sol";

contract PublicTest1 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[0]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest2 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[1]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest3 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[2]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest4 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[3]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest5 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[4]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest6 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[5]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest7 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[6]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest8 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[7]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest9 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[8]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract PublicTest10 is TestChallenge {
    string DATA_PATH = "test/data/inputs.json";
    string DATA_KEY = "[9]";

    constructor() TestChallenge(DATA_PATH, DATA_KEY) {}
}

contract GasEfficiencyTest is MeasureChallenge {
    string DATA_PATH = "test/data/inputs.json";
    constructor() MeasureChallenge(DATA_PATH) {}

    function test_gas_efficiency() external {
        super.test_gas_efficiency(60000);
    }
}