const { ethers } = require("hardhat");
const { expect } = require("chai");
const { 
  time,
  setBalance 
} = require("@nomicfoundation/hardhat-network-helpers");

function TestVote_VV(subsuiteName, input, tests) {
  describe(subsuiteName, function () {
    before(async function () {
      VVFactory = await ethers.getContractFactory("VillageVoting");
    });

    for (let i = 0; i < input.length; ++i) {
      it(tests[i], async () => {
        const voteTokens = input[i].setup.voteTokens.map(BigInt);
        vv = await VVFactory.deploy(
          input[i].setup.villagers, 
          voteTokens, 
          input[i].setup.proposals, 
          input[i].setup.roundDuration
        );  
  
        await vv.deployed();

        for (let j = 0; j < input[i].steps.length; ++j) {
          await time.increase(input[i].steps[j].votingTime); 
          const voter = await ethers.getImpersonatedSigner(
            input[i].steps[j].voter
          );
          setBalance(voter.address, 10n**18n);
    
          if (input[i].steps[j].shouldFail) {
            await expect(vv.connect(voter).vote(
              input[i].steps[j].proposalIds, 
              input[i].steps[j].votes.map(BigInt)
            )).to.be.reverted;
            continue;
          }
        
          await vv.connect(voter).vote(
            input[i].steps[j].proposalIds, 
            input[i].steps[j].votes.map(BigInt)
          );
        }
        
        const roundInfo = await vv.getRoundInfo();
        for (let j = 0; j < input[i].results.votes.length; ++j) { 
          const votes = await vv.getProposalVotePower(
            input[i].setup.proposals[j], 
            roundInfo[1]
          );
          const delta = BigInt(Math.floor(
            input[i].results.votes[j]* 0.05
          ));
          expect(votes).to.be.closeTo(
            input[i].results.votes[j],
            delta,
            "Wrong votes"
          );
        }
      });
    }
  });
}

module.exports.TestVote_VV = TestVote_VV;