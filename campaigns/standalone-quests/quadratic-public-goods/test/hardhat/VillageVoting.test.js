const { 
    TestValidDeployment_VV, 
    TestInvalidDeployment_VV,
} = require("./testsuites/TestDeployment_VV");
const {TestVote_VV} = require("./testsuites/TestVote_VV");
const {TestCountVotes_VV} = require("./testsuites/TestCountVotes_VV");

describe("Village voting (Part 1)", function() {
    let inputs = require("../../test/data/deployment_VV.json");
    let tests = [
        "Valid deployment 1",
        "Valid deployment 2",
        "Valid deployment 3"
    ];
    TestValidDeployment_VV("Public Test 1", inputs.valid, tests);
    
    tests = ["Shouldn't deploy with not enough voteTokens"];
    TestInvalidDeployment_VV(
        "Public Test 2", 
        [inputs["not-enough-voteTokens"]], 
        tests
    );

    inputs = require("../../test/data/vote_VV.json");
    tests = [
        "Valid voting 1", 
        "Valid voting 2", 
        "Valid voting 3", 
        "Valid voting 4", 
        "Invalid voting"
    ];
    TestVote_VV("Public Test 3", inputs, tests);

    inputs = require("../../test/data/countVotes_VV.json");
    tests = [
        "Valid counting 1", 
        "Valid counting 2", 
        "Shouldn't count before the voting ends", 
        "Should fail a non-deployer call"
    ];
    TestCountVotes_VV("Public Test 4", inputs, tests);
});