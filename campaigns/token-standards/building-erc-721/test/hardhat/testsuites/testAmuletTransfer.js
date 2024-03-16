const { ethers } = require("hardhat");
const { expect } = require("chai");

const SAFE_TRANSFER = "safeTransferFrom(address,address,uint256)";
const SAFE_TRANSFER_DATA = "safeTransferFrom(address,address,uint256,bytes)";

function testAmuletTransfer(subsuiteName, input) {
  describe(subsuiteName, function () {
    let AmuletFactory;
    let amulet;

    let creator;
    let user1;
    let user2;

    let amuletID1;
    let amuletID2;
    let amuletID3;

    before(async function () {
      AmuletFactory = await ethers.getContractFactory("Amulet");
      [creator, user1, user2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      amulet = await AmuletFactory.deploy();
      await amulet.deployed();

      for (let i = 0; i < input.startId; i++) {
        await amulet.connect(creator).mint(creator.address, "https://url.com");
      }

      amuletID1 = input.startId;
      amuletID2 = input.startId + 1;
      amuletID3 = input.startId + 2;

      await amulet.connect(creator).mint(user1.address, "https://url1.com");
      await amulet.connect(creator).mint(user2.address, "https://url2.com");
      await amulet.connect(creator).mint(user1.address, "https://url3.com");
    });

    it("Should transfer amulet directly", async function () {
      await amulet.connect(user1)
        .transferFrom(user1.address, user2.address, amuletID1);

      expect(await amulet.balanceOf(user2.address)).to.equal(2);
      expect(await amulet.balanceOf(user1.address)).to.equal(1);

      expect(await amulet.ownerOf(amuletID1)).to.equal(user2.address);  
    });
      
    it("Should transfer amulet indirectly with approval", async function () {
      // Approve
      await amulet.connect(user1).approve(user2.address, amuletID1);

      expect(await amulet.getApproved(amuletID1)).to.equal(user2.address);

      // Transfer
      await amulet.connect(user2)
        .transferFrom(user1.address, user2.address, amuletID1);

      // Check ownership is updated
      expect(await amulet.ownerOf(amuletID1)).to.equal(user2.address);
      expect(await amulet.balanceOf(user2.address)).to.equal(2);
      expect(await amulet.balanceOf(user1.address)).to.equal(1);

      // Check approval is removed
      expect(await amulet.getApproved(amuletID1))
        .to.equal(ethers.constants.AddressZero, "Approval not cleared!");
    });
          
    it("Should transfer amulet indirectly with authorized operator", async function () {
      // Set approval for all
      await amulet.connect(user1).setApprovalForAll(user2.address, true);

      // Transfer
      await amulet.connect(user2)
        .transferFrom(user1.address, user2.address, amuletID1);
      await amulet.connect(user2)
        .transferFrom(user1.address, user2.address, amuletID3);

      // Check ownership is updated
      expect(await amulet.ownerOf(amuletID1)).to.equal(user2.address);
      expect(await amulet.ownerOf(amuletID3)).to.equal(user2.address);
      expect(await amulet.balanceOf(user2.address)).to.equal(3);
      expect(await amulet.balanceOf(user1.address)).to.equal(0);
    });

    it("Should reject unauthorized transferFrom", async function () {
      await amulet.connect(user1)
        .approve(user2.address, amuletID1);
      
      // user2 is not approved to transfer user1's amuletID2
      const transferTx1 = amulet.connect(user2)
        .transferFrom(user1.address, user2.address, amuletID2);
      await expect(transferTx1).to.be.reverted;
      
      // user2 does not own to amuletID3
      const transferTx2 = amulet.connect(user2)
        .transferFrom(user2.address, user1.address, amuletID3);
      await expect(transferTx2).to.be.reverted;
    });

    it("Should reject transferFrom to zero address", async function () {
      const transferTx = amulet.connect(user1).transferFrom(
        user1.address, 
        ethers.constants.AddressZero, 
        amuletID1
      );

      await expect(transferTx).to.be.reverted;
    });
  });
}

function testAmuletSafeTransfer(subsuiteName, input) {

  describe(subsuiteName, function () {
    let AmuletFactory;
    let amulet;

    let creator;
    let user1;
    let user2;

    let amuletID1;
    let amuletID2;
    let amuletID3;

    before(async function () {
      AmuletFactory = await ethers.getContractFactory("Amulet");
      [creator, user1, user2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      amulet = await AmuletFactory.deploy();
      await amulet.deployed();

      for (let i = 0; i < input.startId; i++) {
        await amulet.connect(creator).mint(creator.address, "https://url.com");
      }

      amuletID1 = input.startId;
      amuletID2 = input.startId + 1;
      amuletID3 = input.startId + 2;

      await amulet.connect(creator).mint(user1.address, "https://url1.com");
      await amulet.connect(creator).mint(user2.address, "https://url2.com");
      await amulet.connect(creator).mint(user1.address, "https://url3.com");
    });

    it("Should safe transfer amulet directly", async function () {
      await amulet.connect(user1)[SAFE_TRANSFER](
        user1.address, user2.address, amuletID1);

      expect(await amulet.balanceOf(user2.address)).to.equal(2);
      expect(await amulet.balanceOf(user1.address)).to.equal(1);

      expect(await amulet.ownerOf(amuletID1)).to.equal(user2.address);  
    });
      
    it("Should safe transfer amulet indirectly with approval", async function () {
      // Approve
      await amulet.connect(user1).approve(user2.address, amuletID1);

      expect(await amulet.getApproved(amuletID1)).to.equal(user2.address);

      // Transfer
      await amulet.connect(user2)[SAFE_TRANSFER](
        user1.address, user2.address, amuletID1);

      // Check ownership is updated
      expect(await amulet.ownerOf(amuletID1)).to.equal(user2.address);
      expect(await amulet.balanceOf(user2.address)).to.equal(2);
      expect(await amulet.balanceOf(user1.address)).to.equal(1);

      // Check approval is removed
      expect(await amulet.getApproved(amuletID1))
        .to.equal(ethers.constants.AddressZero, "Approval not cleared!");
    });
          
    it("Should safe transfer amulet indirectly with authorized operator", async function () {
      // Set approval for all
      await amulet.connect(user1).setApprovalForAll(user2.address, true);

      // Transfer
      await amulet.connect(user2)[SAFE_TRANSFER](
        user1.address, user2.address, amuletID1);
      await amulet.connect(user2)[SAFE_TRANSFER](
        user1.address, user2.address, amuletID3);

      // Check ownership is updated
      expect(await amulet.ownerOf(amuletID1)).to.equal(user2.address);
      expect(await amulet.ownerOf(amuletID3)).to.equal(user2.address);
      expect(await amulet.balanceOf(user2.address)).to.equal(3);
      expect(await amulet.balanceOf(user1.address)).to.equal(0);
    });

    it("Should reject unauthorized safeTransferFrom", async function () {
      await amulet.connect(user1)
        .approve(user2.address, amuletID1);

      // user2 is not approved to transfer user1's amuletID2
      const transferTx1 = amulet.connect(user2)[SAFE_TRANSFER](
        user1.address, user2.address, amuletID2);
      await expect(transferTx1).to.be.reverted;

      // user2 does not own to amuletID3
      const transferTx2 = amulet.connect(user2)[SAFE_TRANSFER](
        user2.address, user1.address, amuletID3);
      await expect(transferTx2).to.be.reverted;
    });

    it("Should reject safeTransferFrom to zero address", async function () {
      const transferTx = amulet.connect(user1)[SAFE_TRANSFER](
        user1.address, 
        ethers.constants.AddressZero, 
        amuletID1
      );

      await expect(transferTx).to.be.reverted;
    });

    it("Should safe transfer to compatible receiver", async function () {
      const dummyReceiverFactory = await ethers.getContractFactory("ERC721DummyReceiver");
      const dummyReceiver = await dummyReceiverFactory.deploy();
      await dummyReceiver.deployed();

      await amulet.connect(user1)[SAFE_TRANSFER](
        user1.address, dummyReceiver.address, amuletID1);

      expect(await amulet.ownerOf(amuletID1)).to.equal(dummyReceiver.address);
    });

    it("Should reject safe transfer to incompatible receiver", async function () {
      const dummyReceiverFactory = await ethers.getContractFactory("ERC721DummyReceiver");
      const dummyReceiver = await dummyReceiverFactory.deploy();
      await dummyReceiver.deployed();

      await dummyReceiver.pause();

      const transferTx = amulet.connect(user1)[SAFE_TRANSFER](
        user1.address, dummyReceiver.address, amuletID1);

      await expect(transferTx).to.be.reverted;
    });

    it("Should safe transfer with data", async function () {
      const dummyReceiverFactory = await ethers.getContractFactory("ERC721DummyReceiver");
      const dummyReceiver = await dummyReceiverFactory.deploy();
      await dummyReceiver.deployed();

      const testData = "0x12345678";
      await amulet.connect(user1)[SAFE_TRANSFER_DATA](
        user1.address, dummyReceiver.address, amuletID1, testData);

      expect(await amulet.ownerOf(amuletID1)).to.equal(dummyReceiver.address);
      expect(await dummyReceiver.data()).to.equal(testData);
    });

  });
}

function testAmuletEvents(subsuiteName) {
  describe(subsuiteName, function () {
    let AmuletFactory;
    let amulet;

    let creator;
    let user2;

    let amuletID1;
    let amuletID2;

    before(async function () {
      AmuletFactory = await ethers.getContractFactory("Amulet");
      [creator, user2] = await ethers.getSigners();

      amulet = await AmuletFactory.deploy();
      await amulet.deployed();

      amuletID1 = 0;
      amuletID2 = 1;

      await amulet.connect(creator).mint(creator.address, "https://url1.com");
      await amulet.connect(creator).mint(creator.address, "https://url2.com");
    });

    it("Should emit Approval events", async function () {
      await expect(
        amulet.connect(creator).approve(user2.address, amuletID1)
      ).to.emit(amulet, "Approval").withArgs(
        creator.address, user2.address, amuletID1
      );
    });

    it("Should emit ApprovalForAll events", async function () {
      await expect(
        amulet.connect(creator).setApprovalForAll(user2.address, true)
      ).to.emit(amulet, "ApprovalForAll").withArgs(
        creator.address, user2.address, true
      );
    });

    it("Should emit Transfer events", async function () {
      await expect(
        amulet.connect(creator).mint(creator.address, "https://url3.com")
      ).to.emit(amulet, "Transfer").withArgs(
        ethers.constants.AddressZero, creator.address, 2
      );

      await expect(
        amulet.connect(creator)
          .transferFrom(creator.address, user2.address, amuletID1)
      ).to.emit(amulet, "Transfer").withArgs(
        creator.address, user2.address, amuletID1
      );

      await expect(
        amulet.connect(creator)[SAFE_TRANSFER](creator.address, user2.address, amuletID2)
      ).to.emit(amulet, "Transfer").withArgs(
        creator.address, user2.address, amuletID2
      );

      await expect(
        amulet.connect(user2)[SAFE_TRANSFER_DATA](user2.address, creator.address, amuletID2, "0x")
      ).to.emit(amulet, "Transfer").withArgs(
        user2.address, creator.address, amuletID2
      );
    });

  });
}

module.exports = {
  testAmuletTransfer,
  testAmuletSafeTransfer,
  testAmuletEvents
};