const { ethers } = require("hardhat");
const { expect } = require("chai");
const helpers = require("@nomicfoundation/hardhat-network-helpers");

function testVillageVoting(subsuiteName, inputs) {

  let VVFactory;
  let vv;

  describe(subsuiteName, function () {

    before(async function () {
      VVFactory = await ethers.getContractFactory("VillageVoting");

      for (const villager of inputs.setup.villagers) {
        await helpers.setBalance(villager, ethers.utils.parseEther("1"));
      }
    });

    beforeEach(async function () {
      vv = await VVFactory.deploy(
        inputs.setup.villagers, 
        inputs.setup.tokenBalances, 
        inputs.setup.proposals, 
      );

      await vv.deployed();

    });

    it("Should deploy correctly", async function () {
      // 1. Check balanceOf for each villager
      for (let i = 0; i < inputs.setup.villagers.length; i++) {
        const villager = inputs.setup.villagers[i];

        const actualBalance = await vv.balanceOf(villager);
        expect(actualBalance, "Unexpected villager balance")
          .to.equal(inputs.setup.tokenBalances[i]);
      }

      // 2. Check proposals (order doesn't matter)
      const proposals = await vv.getProposals();
      expect(proposals, "Unexpected proposals")
        .to.have.deep.members(inputs.setup.proposals.map(ethers.BigNumber.from));

    });

    it("Should not have winning proposal before countVotes", async function () {
      const tx = vv.getWinningProposal();
      expect(tx).to.be.reverted;
    });

    it("Should accept valid votes", async function () {

      // 1. Process each vote
      for (const voteInput of inputs.votes) {
        const signer = await ethers.getImpersonatedSigner(voteInput.voter);
        await vv.connect(signer).vote(
          voteInput.votedProposals, 
          voteInput.votedAmounts
        );
      }

      // 2. Check final vote power
      for (let i = 0; i < inputs.expectedVotePower.length; i++) {
        const actualVotePower = await vv.votePower(inputs.setup.proposals[i])
        expect(actualVotePower, "Unexpected final vote power")
          .to.equal(inputs.expectedVotePower[i]);
      }

    });

    it("Should count votes", async function () {

      // 1. Process each vote
      for (const voteInput of inputs.votes) {
        const signer = await ethers.getImpersonatedSigner(voteInput.voter);
        await vv.connect(signer)
          .vote(voteInput.votedProposals, voteInput.votedAmounts);
      }

      // 2. Count Votes
      await helpers.time.increase(604801); // 7 days, 1 second
      await vv.countVotes();

      // 3. Check winner
      const winner = await vv.getWinningProposal();
      expect(winner, "Unexpected winner").to.equal(inputs.expectedWinner);

    });

    it("Should reject double votes", async function () {

      const voteInput = inputs.votes[0];
      const signer = await ethers.getImpersonatedSigner(voteInput.voter);

      // 1. Vote once
      await vv.connect(signer)
        .vote(voteInput.votedProposals, voteInput.votedAmounts);

      // 2. Vote twice (should revert)
      const tx = vv.connect(signer).vote(voteInput.votedProposals, voteInput.votedAmounts);
      await expect(tx).to.be.reverted;

    });

    it("Should reject votes after 7 days", async function () {

      const voteInput = inputs.votes[0];
      const signer = await ethers.getImpersonatedSigner(voteInput.voter);

      // 1. Close voting round
      await helpers.time.increase(604801); // 7 days, 1 second

      // 2. Vote (should revert)
      const tx = vv.connect(signer).vote(voteInput.votedProposals, voteInput.votedAmounts);
      await expect(tx).to.be.reverted;

    });

    it("Should reject vote with insufficient tokens", async function () {

      let voteInput = structuredClone(inputs.votes[0]);
      const signer = await ethers.getImpersonatedSigner(voteInput.voter);

      // 1. Over-increase vote amount
      let balance = await vv.balanceOf(voteInput.voter);
      for (let i = 0; i < voteInput.votedAmounts.length; i++) {
        balance = balance.sub(voteInput.votedAmounts[i]);
      }
      voteInput.votedAmounts[0] = balance.add(voteInput.votedAmounts[0]).add(1);

      // 2. Vote (should revert)
      const tx = vv.connect(signer).vote(voteInput.votedProposals, voteInput.votedAmounts);
      await expect(tx).to.be.reverted;

    });

    it("Should reject vote on inexistent proposal", async function () {

      let voteInput = inputs.inexistentProposalVote;
      const signer = await ethers.getImpersonatedSigner(voteInput.voter);

      // 1. Vote with inexistent proposal (should revert)
      const tx = vv.connect(signer).vote(voteInput.votedProposals, voteInput.votedAmounts);
      await expect(tx).to.be.reverted;

    });

    it("Should reject vote with duplicate proposals", async function () {

      let voteInput = inputs.duplicateProposalVote;
      const signer = await ethers.getImpersonatedSigner(voteInput.voter);

      // 1. Vote with duplicate proposal (should revert)
      const tx = vv.connect(signer).vote(voteInput.votedProposals, voteInput.votedAmounts);
      await expect(tx).to.be.reverted;

    });

    it("Should reject counting before 7 days", async function () {

      // 1. Process each vote
      for (const voteInput of inputs.votes) {
        const signer = await ethers.getImpersonatedSigner(voteInput.voter);
        await vv.connect(signer)
          .vote(voteInput.votedProposals, voteInput.votedAmounts);
      }

      // 2. Count votes before 7 days (should revert)
      const tx = vv.countVotes();
      await expect(tx).to.be.reverted;

    });
  });
}

module.exports.testVillageVoting = testVillageVoting;