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

    before(async function () {
      abiCoder = new ethers.utils.AbiCoder();

      AmuletFactory = await ethers.getContractFactory("Amulet");
      AmuletPouchFactory = await ethers.getContractFactory("AmuletPouch");

      const signers = await ethers.getSigners();
      creator = signers[0];
      users = signers.slice(1, input.numMembers + 2);
    });

    beforeEach(async function () {
      amulet = await AmuletFactory.deploy();
      await amulet.deployed();

      for (let i = 0; i < input.numMembers; i++) {
        await mintAmulet(i, i);
      };

      amuletPouch = await AmuletPouchFactory.deploy(amulet.address);
      await amuletPouch.deployed();
    });

    // Helper function to mint Amulets
    async function mintAmulet(ownerId, tokenId) {
      await amulet.connect(creator).mint(
        users[ownerId].address,
        `https://url${tokenId}.com`
      );
    }
    
    // Helper function to deposit an Amulet (for non-members)
    async function depositAmulet(ownerId, tokenId) {
      await amulet.connect(users[ownerId])[SAFE_TRANSFER](
        users[ownerId].address, 
        amuletPouch.address, 
        tokenId
      );
    }

    // Helper function to deposit an Amulet and request withdrawal of another
    async function exchangeAmulet(ownerId, depositId, withdrawId) {
      await amulet.connect(users[ownerId])[SAFE_TRANSFER_BYTES](
        users[ownerId].address,
        amuletPouch.address,
        depositId,
        abiCoder.encode(["uint"], [withdrawId])
      );
    }

    // Helper function to for majority of members to vote for a withdrawal
    async function voteForWithdrawal(requesterId, withdrawalId) {
      let voteCount = 1;
      for (let i = 0; voteCount <= input.numMembers / 2; i++) {
        if (i == requesterId) {
          continue;
        }

        await amuletPouch.connect(users[i]).voteFor(
          users[requesterId].address, withdrawalId
        );
        voteCount++;
      }

      return voteCount;
    }

    it("Should receive Amulets and register members", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
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
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let depositId = input.numMembers;
      let requester = users[requesterId];

      for (let i = 0; i < withdrawalIds.length; i++) {
        await mintAmulet(requesterId, depositId + i);
        await exchangeAmulet(requesterId, depositId + i, withdrawalIds[i]);

        expect(
          await amuletPouch.isWithdrawRequest(requester.address, withdrawalIds[i])
        ).to.be.true;
        expect(
          await amuletPouch.numVotes(requester.address, withdrawalIds[i])
        ).to.equal(1);
      }
    });

    it("Should reject withdrawal of Amulets with insufficient votes", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let depositId = input.numMembers;
      let requester = users[requesterId];

      await expect(
        amuletPouch.connect(requester).withdraw(withdrawalIds[0])
      ).to.be.reverted;

      await mintAmulet(requesterId, depositId);

      await exchangeAmulet(requesterId, depositId, withdrawalIds[0]);

      await expect(
        amuletPouch.connect(requester).withdraw(withdrawalIds[0])
      ).to.be.reverted;

    });

    it("Should withdraw Amulets with enough votes", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let depositId = input.numMembers;
      let requester = users[requesterId];

      await mintAmulet(requesterId, depositId);
      await exchangeAmulet(requesterId, depositId, withdrawalIds[0]);

      const voteCount = await voteForWithdrawal(requesterId, withdrawalIds[0]);

      expect(
        await amuletPouch.numVotes(requester.address, withdrawalIds[0])
      ).to.equal(voteCount);

      await amuletPouch.connect(requester).withdraw(withdrawalIds[0]);
      expect(
        await amulet.ownerOf(withdrawalIds[0])
      ).to.equal(requester.address);

    });

    it("Should revoke membership and requests after withdrawing Amulet", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let depositId = input.numMembers;
      let requester = users[requesterId];

      for (let i = 0; i < withdrawalIds.length; i++) {
        await mintAmulet(requesterId, depositId + i);
        await exchangeAmulet(requesterId, depositId + i, withdrawalIds[i]);
      }

      await voteForWithdrawal(requesterId, withdrawalIds[0]);

      await amuletPouch.connect(requester).withdraw(withdrawalIds[0]);

      expect(
        await amuletPouch.isMember(requester.address)
      ).to.be.false;

      for (let i = 0; i < withdrawalIds.length; i++) {
        expect(
          await amuletPouch.isWithdrawRequest(requester.address, withdrawalIds[i])
        ).to.be.false;
      }

    });

    it("Should reject vote for an inexistent request", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let requester = users[requesterId];

      const tx = amuletPouch.connect(users[0]).voteFor(
        requester.address, withdrawalIds[0]
      );

      await expect(tx).to.be.reverted;
    });

    it("Should reject vote from a non-member", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let depositId = input.numMembers;
      let requester = users[requesterId];

      await mintAmulet(requesterId, depositId);

      await exchangeAmulet(requesterId, depositId, withdrawalIds[0]);
      
      const tx = amuletPouch.connect(users[input.numMembers]).voteFor(
        requester.address, withdrawalIds[0]
      )

      await expect(tx).to.be.reverted;
    });


    it("Should allow user to re-register as member after withdrawal", async function () {
      for (let i = 0; i < input.numMembers; i++) {
        await depositAmulet(i, i);
      }

      let { requesterId, withdrawalIds } = input.withdrawRequest;
      let depositId = input.numMembers;
      let requester = users[requesterId];

      await mintAmulet(requesterId, depositId);

      await exchangeAmulet(requesterId, depositId, withdrawalIds[0]);

      await voteForWithdrawal(requesterId, withdrawalIds[0]);

      await amuletPouch.connect(requester).withdraw(withdrawalIds[0]);

      await mintAmulet(requesterId, depositId + 1);
      await depositAmulet(requesterId, depositId + 1);

      // Requester should re-register as member.
      expect(
        await amuletPouch.isMember(requester.address)
      ).to.be.true;

      // Previously pending requests should still remain deleted.
      expect(
        await amuletPouch.isWithdrawRequest(requester.address, withdrawalIds[0])
      ).to.be.false;
      
      expect(
        await amuletPouch.numVotes(requester.address, withdrawalIds[0])
      ).to.equal(0);

      // New requests should be registered.
      await exchangeAmulet(requesterId, withdrawalIds[0], withdrawalIds[1]);

      expect(
        await amuletPouch.isWithdrawRequest(requester.address, withdrawalIds[1])
      ).to.be.true;
      
      expect(
        await amuletPouch.numVotes(requester.address, withdrawalIds[1])
      ).to.equal(1);

    });
  });

}

module.exports.testAmuletPouch = testAmuletPouch;