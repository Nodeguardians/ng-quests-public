const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCrates(subsuiteName, input) {

  describe(subsuiteName, function () {
    let cratesContract;
    const crates = input.crates.map((crate) => {
      return {
        id: crate.id.toString(),
        size: crate.size.toString(),
        strength: crate.strength.toString()
      }
    });

    beforeEach(async function () {
      const cratesFactory = await ethers.getContractFactory("Crates");
      cratesContract = await cratesFactory.deploy();

      await cratesContract.deployed();
    });

    it("Should insert and retrieve crates", async function () {
      for (let crate of crates) {
        await cratesContract.insertCrate(
          crate.id.toString(), 
          crate.size.toString(), 
          crate.strength.toString()
        );
      }

      for (let crate of crates) {
        const { size, strength } = await cratesContract.getCrate(crate.id.toString());
        expect(size).to.equal(crate.size.toString());
        expect(strength).to.equal(crate.strength.toString());
      }

    });

    it("Should fail if inserting an existing crate", async function () {
      await cratesContract.insertCrate(input.crates[0].id, input.crates[0].size, input.crates[0].strength);

      await expect(cratesContract.insertCrate(
        input.crates[0].id, input.crates[0].size, input.crates[0].strength
      )).to.be.reverted;
    });

    it("Should fail if retrieving an inexistent crate", async function () {
      await expect(cratesContract.getCrate(input.crates[0].id)).to.be.reverted;
    });

    it("Should iterate crates", async function () {
      for (let crate of crates) {
        await cratesContract.insertCrate(crate.id, crate.size, crate.strength);
      }

      const expectedIds = crates
        .map(crate => ethers.BigNumber.from(crate.id));

      const actualIds = await cratesContract.getCrateIds();
      expect(actualIds).to.have.deep.members(expectedIds);

    });
  });

}

module.exports.testCrates = testCrates;