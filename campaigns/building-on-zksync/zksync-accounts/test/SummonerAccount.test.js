const { testSummonerAccount } = require("./testsuites/TestSummonerAccount.js");

describe("Summoner Account (Part 2)", function() {
    const inputs = require("./data/inputs.json");
    testSummonerAccount('Public Test 1', inputs[0]);
});