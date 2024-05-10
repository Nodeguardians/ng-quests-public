const { ethers } = require("hardhat");
const { expect } = require("chai");

function testDoubloonTransfer(subsuiteName, input) {
  describe(subsuiteName, function () {
    let DoubloonFactory;
    let doubloon;

    let creator;
    let user1;
    let user2;

    before(async function () {
      DoubloonFactory = await ethers.getContractFactory("Doubloon");

      [creator, user1, user2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      doubloon = await DoubloonFactory.deploy(input.supply);
      await doubloon.deployed();
    });

    it("Should have balanceOf", async function () {
      expect(
        await doubloon.balanceOf(creator.address),
        "Unexpected balance for creator!"
      ).to.equal(input.supply);
    });

    it("Should transfer doubloons with transfer()", async function () {
      const result = await doubloon.connect(creator)
        .callStatic.transfer(user1.address, input.transferAmount1);
      expect(result).to.be.true;

      await doubloon.connect(creator).transfer(
        user1.address, 
        input.transferAmount1
      );

      expect(await doubloon.totalSupply()).to.equal(input.supply);
      expect(await doubloon.balanceOf(user1.address))
        .to.equal(input.transferAmount1);
      expect(await doubloon.balanceOf(creator.address))
        .to.equal(input.supply - input.transferAmount1);

      await doubloon.connect(user1).transfer(
        user2.address, 
        input.transferAmount2
      );

      expect(await doubloon.balanceOf(user2.address))
        .to.equal(input.transferAmount2);
      expect(await doubloon.balanceOf(user1.address))
        .to.equal(input.transferAmount1 - input.transferAmount2);

    });

    it("Should reject invalid transfer with transfer()", async function () {
      let badTx = doubloon.connect(creator).transfer(
        user1.address, input.supply + 1
      );
      await expect(badTx).to.be.reverted;

      badTx = doubloon.connect(creator).transfer(
        user2.address, input.supply + 1
      );
      await expect(badTx).to.be.reverted;
    });

    it("Should approve allowance", async function () {
      await doubloon.connect(creator).approve(user1.address, input.transferAmount1);
      const allowance = await doubloon.allowance(creator.address, user1.address);

      expect(allowance).to.equal(input.transferAmount1);
    });

    it("Should transfer doubloon with transferFrom()", async function () {
      await doubloon.connect(creator).approve(user1.address, input.transferAmount1);

      const result = await doubloon.connect(user1)
        .callStatic.transferFrom(creator.address, user1.address, input.transferAmount1);
      expect(result).to.be.true;

      await doubloon.connect(user1)
        .transferFrom(creator.address, user1.address, input.transferAmount1);

      expect(await doubloon.totalSupply()).to.equal(input.supply);
      expect(await doubloon.balanceOf(user1.address))
        .to.equal(input.transferAmount1);
      expect(await doubloon.balanceOf(creator.address))
        .to.equal(input.supply - input.transferAmount1);

      await doubloon.connect(user1).approve(user2.address, input.transferAmount2);
      await doubloon.connect(user2)
        .transferFrom(user1.address, creator.address, input.transferAmount2);

      expect(await doubloon.balanceOf(user1.address))
        .to.equal(input.transferAmount1 - input.transferAmount2);
      expect(await doubloon.balanceOf(creator.address))
        .to.equal(input.supply - input.transferAmount1 + input.transferAmount2);

    });

    it("Should decrease allowance after transferFrom()", async function () {
      await doubloon.connect(creator)
        .approve(user1.address, input.transferAmount1);

      await doubloon.connect(user1).transferFrom(
        creator.address, 
        user1.address, 
        input.transferAmount1 - 1
      );

      allowance = await doubloon.allowance(creator.address, user1.address);

      expect(allowance).to.equal(1);
    });

    it("Should reject invalid transfer with transferFrom() - not enough funds", async function () {
      await doubloon.connect(creator).approve(user1.address, input.supply + 1);

      const badTx = doubloon.connect(user1)
        .transferFrom(creator.address, user1.address, input.supply + 1);

      await expect(badTx).to.be.reverted;
    });

    it("Should reject invalid transfer with transferFrom() - not enough allowance", async function () {
      await doubloon.connect(creator).approve(user1.address, input.supply - 1);
      
      let badTx = doubloon.connect(user1)
        .transferFrom(creator.address, user1.address, input.supply);

      await expect(badTx).to.be.reverted;

      badTx = doubloon.connect(user2)
        .transferFrom(creator.address, user1.address, input.supply);

      await expect(badTx).to.be.reverted;
    });

  });
}

module.exports.testDoubloonTransfer = testDoubloonTransfer;