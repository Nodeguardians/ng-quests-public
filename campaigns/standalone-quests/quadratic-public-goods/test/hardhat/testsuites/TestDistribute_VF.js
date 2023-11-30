const { ethers } = require("hardhat");
const { expect } = require("chai");
const { 
  time, 
  setBalance 
} = require("@nomicfoundation/hardhat-network-helpers");

function TestDistribute_VF(subsuiteName, input, tests) {
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
          setBalance(input[i].setup.villagers[j], 40n**22n);
          const donator = await ethers.getImpersonatedSigner(
            input[i].setup.villagers[j]
          );
          await vf.connect(donator).donate({
            value: BigInt(input[i].setup.donations[j])
          });
        }

        for (let j = 0; j < input[i].votes.length; ++j) {
          const voter = await ethers.getImpersonatedSigner(
            input[i].votes[j].voter
          );
          await vf.connect(voter).vote(
            input[i].votes[j].projectId, 
            input[i].votes[j].vote
          );
        }

        // Test distributes before distribution time
        await expect(vf.distribute()).to.be.reverted;

        await time.increase(input[i].setup.distributionTime)

        if (input[i].result.shouldFail) {
          await expect(vf.distribute()).to.be.reverted;    
          return;
        }

        await vf.distribute();

        let totalAmount = 0n;
        for (let j = 0; j < input[i].setup.projects.length; ++j) {
          const actualFunds = BigInt(
            await vf.getFunds(input[i].setup.projects[j])
          );
          const delta = BigInt(Math.floor(
            input[i].result.funds[j] * 0.05
          ));
          expect(actualFunds).to.be.closeTo(
            BigInt(input[i].result.funds[j]),
            delta,
            "Wrong funds"
          );
          totalAmount += actualFunds;
        }

        expect(await ethers.provider.getBalance(vf.address)).to.be.gte(
          totalAmount, 
          "Total amount should be less or equal to balance"
        );
      });
    }

    if (tests.length !== input.length) {
      it(tests[tests.length - 1], async () => {
        vf = await VFFactory.deploy(
          input[0].setup.villagers, 
          input[0].setup.projects, 
          input[0].setup.voteDuration
        );  

        await vf.deployed();

        for (let j = 0; j < input[0].setup.donations.length; ++j) {
          setBalance(input[0].setup.villagers[j], 40n**22n);
          const donator = await ethers.getImpersonatedSigner(
            input[0].setup.villagers[j]
          );
          await vf.connect(donator).donate({
            value: BigInt(input[0].setup.donations[j])
          });
        }

        for (let j = 0; j < input[0].votes.length; ++j) {
          const voter = await ethers.getImpersonatedSigner(
            input[0].votes[j].voter
          );
          await vf.connect(voter).vote(
            input[0].votes[j].projectId, 
            input[0].votes[j].vote
          );
        }

        await time.increase(input[0].setup.distributionTime)

        await expect(vf.connect(
          await ethers.getImpersonatedSigner(input[0].setup.villagers[0])
        ).distribute()).to.be.reverted;
      });
    }
  });
}

module.exports.TestDistribute_VF = TestDistribute_VF;