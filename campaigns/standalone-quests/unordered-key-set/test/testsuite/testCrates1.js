const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCrates(input) {

  describe(input.name, function () {
    let cratesContract;

    beforeEach(async function () {
      const cratesFactory = await ethers.getContractFactory("Crates");
      cratesContract = await cratesFactory.deploy();

      await cratesContract.deployed();
    });

    it("Should insert and retrieve crates", async function () {
      for (let crate of input.crates) {
        await cratesContract.insertCrate(crate.id, crate.size, crate.strength);
      }

      for (let crate of input.crates) {
        const { size, strength } = await cratesContract.getCrate(crate.id);
        expect(size).to.equal(crate.size);
        expect(strength).to.equal(crate.strength);
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
      for (let crate of input.crates) {
        await cratesContract.insertCrate(crate.id, crate.size, crate.strength);
      }

      const expectedIds = input.crates
        .map(crate => ethers.BigNumber.from(crate.id));

      const actualIds = (await cratesContract.getCrateIds())
        .map(id => ethers.BigNumber.from(id));
      
      expect(actualIds).to.have.deep.members(expectedIds);

    });
  });

}

module.exports.testCrates = testCrates;
