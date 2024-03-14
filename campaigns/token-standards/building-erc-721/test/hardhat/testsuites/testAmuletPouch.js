const { ethers } = require("hardhat");
const { expect } = require("chai");

const SAFE_TRANSFER = "safeTransferFrom(address,address,uint256)";
const SAFE_TRANSFER_BYTES = "safeTransferFrom(address,address,uint256,bytes)";

function testAmuletPouch(subsuiteName, input) {
  describe(subsuiteName, function () {

    let abiCoder;

    let AmuletFactory;
    let amulet;

    let AmuletPouchFactory;
    let amuletPouch;

    let creator;
    let users;
    let totalAmulets;

    before(async function () {
      abiCoder = new ethers.utils.AbiCoder();

      AmuletFactory = await ethers.getContractFactory("Amulet");
      AmuletPouchFactory = await ethers.getContractFactory("AmuletPouch");

      const signers = await ethers.getSigners();
      creator = signers[0];
      users = signers.slice(1, input.numMembers + 2);
    });

    beforeEach(async function () {
      totalAmulets = 0;
      amulet = await AmuletFactory.deploy();
      await amulet.deployed();

      amuletPouch = await AmuletPouchFactory.deploy(amulet.address);
      await amuletPouch.deployed();
    });

    it("Should receive Amulets and register members", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
        expect(await amuletPouch.isMember(users[i].address)).to.be.true;
      }

      expect(await amuletPouch.totalMembers()).to.equal(input.numMembers);
    });

    it("Should reject other ERC721 tokens", async function () {
      const amulet2 = await AmuletFactory.deploy();
      await amulet2.deployed();

      await amulet2.connect(creator).mint(
        users[0].address, 
        `https://url0.com`
      );

      const tx = amulet2.connect(users[0])[SAFE_TRANSFER](
        users[0].address, 
        amuletPouch.address, 
        0
      );
      await expect(tx).to.be.reverted;
    });

    it("Should register request to withdraw Amulets", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      for (let i = 0; i < input.withdrawRequests.length; i++) {
        const { requesterId, withdrawalId } = input.withdrawRequests[i];
        const requester = users[requesterId];

        const tx = exchangeAmulet(requester, withdrawalId);

        await expect(tx).to.emit(amuletPouch, "WithdrawRequested")
          .withArgs(requester.address, withdrawalId, i);

        expect(await amuletPouch.withdrawRequest(i))
          .to.deep.equal([requester.address, withdrawalId]);
        expect(await amuletPouch.numVotes(i)).to.equal(1);
      }
    });
    
    it("Should reject withdrawal of Amulets with insufficient votes", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      for (let i = 0; i < input.withdrawRequests.length; i++) {
        const { requesterId, withdrawalId } = input.withdrawRequests[i];
        const requester = users[requesterId];

        await exchangeAmulet(requester, withdrawalId);

        await expect(
          amuletPouch.connect(requester).withdraw(i)
        ).to.be.reverted;
      }

    });
    
    it("Should withdraw Amulets with enough votes", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      for (let i = 0; i < input.withdrawRequests.length; i++) {
        const { requesterId, withdrawalId } = input.withdrawRequests[i];
        const requester = users[requesterId];

        await exchangeAmulet(requester, withdrawalId);
      }

      // Vote for some withdraw request
      const { requesterId } = input.withdrawRequests[input.approvedRequestId];
      let numVotes = 1;
      for (let i = 0; numVotes <= input.numMembers / 2; i++) {
        if (i == requesterId) { continue; }

        await amuletPouch.connect(users[i])
          .voteFor(input.approvedRequestId);

        numVotes++;
      }

      // Voted withdrawal should be authorized. Other withdrawals should still revert.
      for (let i = 0; i < input.withdrawRequests.length; i++) {
        const { requesterId, withdrawalId } = input.withdrawRequests[i];
        const requester = users[requesterId];

        const expectedNumVotes = (i == input.approvedRequestId)
          ? numVotes : 1;
        expect(await amuletPouch.numVotes(i)).to.equal(expectedNumVotes);

        const withdrawalTx = amuletPouch.connect(requester).withdraw(i);

        if (i == input.approvedRequestId) {
          await withdrawalTx;
          expect(await amulet.ownerOf(withdrawalId)).to.equal(requester.address);
        } else {
          await expect(withdrawalTx).to.be.reverted;
        }
      }

    });

    it("Should reject withdrawal of Amulets from unauthorized caller", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      const { requesterId, withdrawalId } = input.withdrawRequests[input.approvedRequestId];
      const requester = users[requesterId];

      await exchangeAmulet(requester, withdrawalId);

      // Vote for some withdraw request
      let numVotes = 1;
      for (let i = 0; numVotes <= input.numMembers / 2; i++) {
        if (i == requesterId) { continue; }

        await amuletPouch.connect(users[i]).voteFor(0);

        numVotes++;
      }

      // Should revert since users[0] is not requester
      const unauthorizedWithdraw = amuletPouch.connect(users[0]).withdraw(0);
      await expect(unauthorizedWithdraw).to.be.reverted;

    });

    it("Should reject vote from a non-member", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      const { requesterId, withdrawalId } = input.withdrawRequests[0];
      const requester = users[requesterId];

      await exchangeAmulet(requester, withdrawalId);
      
      const nonMember = users[input.numMembers];
      const nonMemberVote = amuletPouch.connect(nonMember).voteFor(0);

      await expect(nonMemberVote).to.be.reverted;
    });

    it("Should reject duplicate vote", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      const { requesterId, withdrawalId } = input.withdrawRequests[0];
      const requester = users[requesterId];

      await exchangeAmulet(requester, withdrawalId);

      await amuletPouch.connect(users[0]).voteFor(0);
      const duplicateVote = amuletPouch.connect(users[0]).voteFor(0);

      await expect(duplicateVote).to.be.reverted;
    });
    
    it("Should reject vote for an inexistent request", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(users[i]);
      }

      for (let i = 0; i < input.withdrawRequests.length; i++) {
        const { requesterId, withdrawalId } = input.withdrawRequests[i];
        const requester = users[requesterId];

        await exchangeAmulet(requester, withdrawalId);
      }

      // Should revert since requestId does not exist
      const inexistentRequestVote = amuletPouch.connect(users[0])
        .voteFor(input.withdrawRequests.length);
      await expect(inexistentRequestVote).to.be.reverted;
    });

    // Helper function to deposit an Amulet (for non-members)
    async function depositAmulet(owner) {
      await amulet.connect(creator).mint(
        owner.address,
        `https://url${totalAmulets}.com`
      );
      return amulet.connect(owner)[SAFE_TRANSFER](
        owner.address, 
        amuletPouch.address, 
        totalAmulets++
      );

    }

    // Helper function to deposit an Amulet and request withdrawal of another
    async function exchangeAmulet(owner, withdrawId) {
      await amulet.connect(creator).mint(
        owner.address,
        `https://url${totalAmulets}.com`
      );
      return amulet.connect(owner)[SAFE_TRANSFER_BYTES](
        owner.address,
        amuletPouch.address,
        totalAmulets,
        abiCoder.encode(["uint"], [withdrawId])
      );
    }

  });

}

module.exports.testAmuletPouch = testAmuletPouch;