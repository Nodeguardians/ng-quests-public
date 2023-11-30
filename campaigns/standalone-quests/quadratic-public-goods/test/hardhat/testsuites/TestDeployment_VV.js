const { ethers } = require("hardhat");
const { expect } = require("chai");

function TestValidDeployment_VV(subsuiteName, input, tests) {
  describe(subsuiteName, function () {
    before(async function () {
      VVFactory = await ethers.getContractFactory("VillageVoting");
    });

    for (let i = 0; i < input.length; ++i) {
      it(tests[i], async () => {
        vv = await VVFactory.deploy(
          input[i].villagers, 
          input[i].voteTokens, 
          input[i].proposals, 
          input[i].roundDuration
        );  
        
        await vv.deployed();
        const deploymentTime = 
          (await ethers.provider.getBlock('latest')).timestamp;
      
        let totalVotesExpected = 0;
        let totalVotes = 0n;
        for (let j = 0; j < input[i].villagers.length; ++j) {
          const vp = await vv.balanceOf(input[i].villagers[j]);
          expect(vp).to.equal(
            input[i].voteTokens[j],
            "Wrong villager balance"
          );
          totalVotes += BigInt(vp);
          totalVotesExpected += input[i].voteTokens[j];
        }
      
        let activeProposals = await vv.getActiveProposals();
        activeProposals = activeProposals.slice().sort((a, b) => a - b);
        expect(activeProposals)
          .to.deep.equal(input[i].proposals, "Wrong active proposals");
      
        expect(totalVotes)
          .to.equal(totalVotesExpected, "Wrong total votes");
        const roundInfo = await vv.getRoundInfo();
        expect(0n)
          .to.equal(roundInfo[0], "Wrong winner");
        expect(deploymentTime + input[i].roundDuration).to.gte(
          roundInfo[2], 
          "Wrong round end time"
        );
      });
    }
  });
}

function TestInvalidDeployment_VV(subsuiteName, input, tests) {
  describe(subsuiteName, function () {
    before(async function () {
      VVFactory = await ethers.getContractFactory("VillageVoting");
    });
    
    for (let i = 0; i < input.length; ++i) {
      it(tests[i], async () => {
        await expect(VVFactory.deploy(
          input[i].villagers, 
          input[i].voteTokens, 
          input[i].proposals, 
          input[i].roundDuration
        )).to.be.reverted;
      });
    }    
  });
}

module.exports.TestValidDeployment_VV = TestValidDeployment_VV;
module.exports.TestInvalidDeployment_VV = TestInvalidDeployment_VV;