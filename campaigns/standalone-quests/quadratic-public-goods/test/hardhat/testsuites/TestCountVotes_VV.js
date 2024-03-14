const { ethers } = require("hardhat");
const { expect } = require("chai");
const { 
  time, 
  setBalance 
} = require("@nomicfoundation/hardhat-network-helpers");

function TestCountVotes_VV(subsuiteName, input, tests) {
  describe(subsuiteName, function () {
    before(async function () {
      VVFactory = await ethers.getContractFactory("VillageVoting");
    });

    for (let i = 0; i < input.length; ++i) {
      it(tests[i], async () => {
        vv = await VVFactory.deploy(
          input[i].setup.villagers, 
          input[i].setup.voteTokens, 
          input[i].setup.proposals, 
          input[i].setup.roundDuration
        );  
  
        await vv.deployed();
        const deploymentTime = 
          (await ethers.provider.getBlock('latest')).timestamp;
        
        const defaultRound = (await vv.getRoundInfo())[1];
        for (let j = 0; j < input[i].rounds.length; ++j) {
          let roundInfo = await vv.getRoundInfo();

          expect(roundInfo[1]).to.equal(
            BigInt(j) + BigInt(defaultRound), 
            "Wrong round number"
          );
          expect(roundInfo[2]).to.lte(
            deploymentTime + input[i].setup.roundDuration, 
            "Wrong round end time"
          );
    
          for (let k = 0; k < input[i].rounds[j].steps.length; ++k) {      
            const voter = await ethers.getImpersonatedSigner(
              input[i].rounds[j].steps[k].voter
            );
            setBalance(voter.address, 10n**18n);
            await vv.connect(voter).vote(
              input[i].rounds[j].steps[k].proposalIds, 
              input[i].rounds[j].steps[k].votes
            );
          }

          await time.increase(input[i].rounds[j].countTime);    
    
          if (input[i].setup.shouldFail) {
            await expect(vv.countVotes()).to.be.reverted;
            return;
          }

          await vv.countVotes();
          
          roundInfo = await vv.getRoundInfo();
          expect(roundInfo[0])
            .to.equal(input[i].rounds[j].winner, "Wrong winner");

          let activeProposals = await vv.getActiveProposals();
          activeProposals = activeProposals.slice().sort((a, b) => a - b);
          expect(activeProposals).to.deep.equal(
            input[i].rounds[j].activeProposals, 
            "Wrong active proposals"
          );
        }
      });
    }

    if (tests.length !== input.length) {
      it(tests[tests.length - 1], async () => {
        vv = await VVFactory.deploy(
          input[0].setup.villagers, 
          input[0].setup.voteTokens, 
          input[0].setup.proposals, 
          input[0].setup.roundDuration
        );  

        await vv.deployed();
      
        for (let j = 0; j < input[0].rounds.length; ++j) {  
          for (let k = 0; k < input[0].rounds[j].steps.length; ++k) {      
            const voter = await ethers.getImpersonatedSigner(
              input[0].rounds[j].steps[k].voter
            );
            setBalance(voter.address, 10n**18n);
            await vv.connect(voter).vote(
              input[0].rounds[j].steps[k].proposalIds, 
              input[0].rounds[j].steps[k].votes
            );
          }

          await time.increase(input[0].rounds[j].countTime);  

          await expect(vv.connect(
            await ethers.getImpersonatedSigner(input[0].setup.villagers[0])
          ).countVotes()).to.be.reverted;
        }
      });
   }
  });
}

module.exports.TestCountVotes_VV = TestCountVotes_VV;