const { ethers } = require("hardhat");
const { expect } = require("chai");

function testDoubloonCreation(subsuiteName, input) {
  describe(subsuiteName, function () {
    let doubloon;

    before(async function () {
      const DoubloonFactory = await ethers.getContractFactory("Doubloon");
      doubloon = await DoubloonFactory.deploy(input.supply);

      await doubloon.deployed();
    });

    it("Should have name", async function () {
      expect(await doubloon.name()).to.equal("Doubloon");
    });

    it("Should have symbol", async function () {
      expect(await doubloon.symbol()).to.equal("DBL");
    });

    it("Should have total supply", async function () {
      expect(await doubloon.totalSupply()).to.equal(input.supply);
    });
  });
}

module.exports.testDoubloonCreation = testDoubloonCreation;