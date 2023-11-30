// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestDeployment_VF.sol";
import "./testsuites/TestDonate_VF.sol";
import "./testsuites/TestVote_VF.sol";
import "./testsuites/TestDistribute_VF.sol";

contract PublicTest1 is TestDeployment_VF {
    string PATH = "test/data/deployment_VF.json";
    constructor() TestDeployment_VF(PATH) {} 

    function test_valid_deployment() external {
        _test_valid_deployment("[0]");
        _test_valid_deployment("[1]");
    }
}

contract PublicTest2 is TestDonate_VF {
    string PATH = "test/data/donate_VF.json";
    constructor() TestDonate_VF(PATH) {} 

    function test_donate_1() external {
        _test_donate("[0]");
    }

    function test_donate_2() external {
        _test_donate("[1]");
    }
}

contract PublicTest3 is TestVote_VF {
    string PATH = "test/data/vote_VF.json";
    constructor() TestVote_VF(PATH) {} 

    function test_votes_1() external {
        _test_votes("[0]");
    }

    function test_votes_2() external {
        _test_votes("[1]");
    }

    function test_votes_3() external {
        _test_votes("[2]");
    }

    function test_votes_4() external {
        _test_votes("[3]");
    }

    function test_votes_5() external {
        _test_votes("[4]");
    }
}

contract PublicTest4 is TestDistribute_VF {
    string PATH = "test/data/distribute_VF.json";
    constructor() TestDistribute_VF(PATH) {} 

    function test_distribute_1() external {
        _test_distribute("[0]");
    }

    function test_distribute_2() external {
        _test_distribute("[1]");
    }

    function test_distribute_3() external {
        _test_distribute("[2]");
    }

    function test_distribute_4() external {
        _test_distribute("[3]");
    }
}