const { ethers } = require("hardhat");
const { expect } = require("chai");
const { 
  time, 
  setBalance 
} = require("@nomicfoundation/hardhat-network-helpers");

function TestVote_VF(subsuiteName, input, tests) {
  describe(subsuiteName, function () {
    before(async function () {
      VFFactory = await ethers.getContractFactory("VillageFunding");
    });

    for (let i = 0; i < input.length; ++i) {
      it(tests[i], async () => {
        vf = await VFFactory.deploy(
          input[i].setup.villagers, 
          input[i].setup.projects, 
          input[i].setup.voteDuration
        );  
  
        await vf.deployed();

        for (let j = 0; j < input[i].setup.donations.length; ++j) {
          setBalance(input[i].setup.villagers[j], 20n**18n);
          const donator = await ethers.getImpersonatedSigner(
            input[i].setup.villagers[j]
          );
          await vf.connect(donator).donate({
            value: BigInt(input[i].setup.donations[j])
          });
        }

        for (let j = 0; j < input[i].steps.length; ++j) {
          await time.increase(input[i].steps[j].voteTime); 
          const voter = await ethers.getImpersonatedSigner(
            input[i].steps[j].voter
          );

          if (input[i].steps[j].shouldFail) {
            await expect(vf.connect(voter).vote(
              input[i].steps[j].projectId, 
              input[i].steps[j].vote
            )).to.be.reverted;
            continue;
          }

          await vf.connect(voter).vote(
            input[i].steps[j].projectId, 
            input[i].steps[j].vote
          );
        }

        for (let j = 0; j < input[i].setup.villagers.length; ++j) {
          let actualVotePower = await vf.getVotePower(
            input[i].setup.villagers[j]
          );
          const delta = BigInt(Math.floor(
            input[i].result.votePower[j] * 0.05
          ));
          expect(actualVotePower).to.be.closeTo(
            input[i].result.votePower[j],
            delta,
            "Wrong vote power"
          );
        }

        for (let j = 0; j < input[i].setup.projects.length; ++j) {
          const contribution = await vf.getContributions(
            input[i].setup.projects[j]
          );
          const delta = BigInt(Math.floor(
            input[i].result.projectVotes[j] * 0.05
          ));
          expect(contribution[0]).to.be.closeTo(
            input[i].result.projectVotes[j],
            delta,
            "Wrong project votes"
          );
          expect(contribution[1]).to.be.equal(
            input[i].result.projectNumberOfPeople[j], 
            "Wrong project number of people");
        }
      });
    }
  });
}

module.exports.TestVote_VF = TestVote_VF;