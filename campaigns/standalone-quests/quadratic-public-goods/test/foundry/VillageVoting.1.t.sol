// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./testsuites/TestDeployment_VV.sol";
import "./testsuites/TestVote_VV.sol";
import "./testsuites/TestCountVotes_VV.sol";

contract PublicTest1 is TestDeployment_VV {
    string PATH = "test/data/deployment_VV.json";
    constructor() TestDeployment_VV(PATH) {}

    function test_valid_deployment_1() external {
        _test_valid_deployment(".valid[0]");
    }

    function test_valid_deployment_2() external {
        _test_valid_deployment(".valid[1]");
    }

    function test_valid_deployment_3() external {
        _test_valid_deployment(".valid[2]");
    }

}

contract PublicTest2 is TestDeployment_VV {
    string PATH = "test/data/deployment_VV.json";    
    constructor() TestDeployment_VV(PATH) {}

    function test_invalid_deployment_not_enough_voteTokens() external {
        _test_invalid_deployment(".not-enough-voteTokens");
    }
}

contract PublicTest3 is TestVote_VV {
    string PATH = "test/data/vote_VV.json";
    constructor() TestVote_VV(PATH) {} 

    function test_valid_votes_1() external {
        _test_votes("[0]");
    }
    
    function test_valid_votes_2() external {
        _test_votes("[1]");
    }    
    
    function test_valid_votes_3() external {
        _test_votes("[2]");
    }

    function test_valid_votes_4() external {
        _test_votes("[3]");
    }

    function test_invalid_votes() external {
        _test_votes("[4]");
    }
}

contract PublicTest4 is TestCountVotes_VV {
    string PATH = "test/data/countVotes_VV.json";
    constructor() TestCountVotes_VV(PATH) {} 

    function test_count_1() external {
        _test_count_votes("[0]");
    }

    function test_count_2() external {
        _test_count_votes("[1]");
    }

    function test_count_before_voting_ends() external {
        _test_count_votes("[2]");
    }
}