const { 
    TestValidDeployment_VF, 
    TestInvalidDeployment_VF,
} = require("./testsuites/TestDeployment_VF");
const { TestDonate_VF } = require("./testsuites/TestDonate_VF");
const { TestVote_VF } = require("./testsuites/TestVote_VF");
const { TestDistribute_VF } = require("./testsuites/TestDistribute_VF");

describe("Village funding (Part 2)", function() {
    let inputs = require("../../test/data/deployment_VF.json");
    TestValidDeployment_VF("Public Test 1", inputs);

    inputs = require("../../test/data/donate_VF.json");
    TestDonate_VF("Public Test 2", inputs);

    inputs = require("../../test/data/vote_VF.json");
    let tests = [
        "Test voting 1", 
        "Test voting 2", 
        "Test voting 3", 
        "Test voting 4", 
        "Test voting 5"
    ];
    TestVote_VF("Public Test 3", inputs, tests);

    inputs = require("../../test/data/distribute_VF.json");
    tests = [
        "Valid distribution 1", 
        "Valid distribution 2", 
        "Valid distribution 3", 
        "Shouldn't distribute before the voting ends", 
        "Should fail a non-deployer call"
    ];
    TestDistribute_VF("Public Test 4", inputs, tests);
});
