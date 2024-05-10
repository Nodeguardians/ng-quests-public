const { ethers } = require("hardhat");
const { expect } = require("chai");

function testDoubloonEvents(subsuiteName, input) {
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

    it("Should emit Transfer event on transfer()", async function () {
      await expect(
        doubloon.connect(creator)
          .transfer(user1.address, input.transferAmount1)
      ).to.emit(doubloon, "Transfer").withArgs(
        creator.address, user1.address, input.transferAmount1
      );
    });

    it("Should emit Approval event on approve()", async function () {
      await expect(
        doubloon.connect(creator)
          .approve(user1.address, input.transferAmount1)
      ).to.emit(doubloon, "Approval").withArgs(
        creator.address, user1.address, input.transferAmount1
      );
    });

    it("Should emit Transfer event on transferFrom()", async function () {
      await doubloon.connect(creator).approve(
        user1.address, input.transferAmount1
      );

      await expect(
        doubloon.connect(user1)
          .transferFrom(creator.address, user1.address, input.transferAmount1)
      ).to.emit(doubloon, "Transfer").withArgs(
        creator.address, user1.address, input.transferAmount1
      );
    });
  });
}

module.exports.testDoubloonEvents = testDoubloonEvents;