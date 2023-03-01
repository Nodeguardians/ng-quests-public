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

    it("Should delete crates", async function () {
      for (let crate of input.crates) {
        await cratesContract.insertCrate(crate.id, crate.size, crate.strength);
      }

      // Check crates have been deleted
      for (let index of input.deleteIndices) {
        await cratesContract.deleteCrate(input.crates[index].id);
        await expect(cratesContract.getCrate(input.crates[index].id)).to.be.reverted;
      }

    });

    it("Should be gas efficient", async function () {
      for (let crate of input.crates) {
        await cratesContract.insertCrate(
          crate.id, crate.size, crate.strength, 
          { gasLimit: input.gasPerInsert }
        );
      }

      for (let index of input.deleteIndices) {
        await cratesContract.deleteCrate(
          input.crates[index].id,
          { gasLimit: input.gasPerDelete }
        );
      }

      expect(
        await cratesContract.estimateGas.getCrateIds()
        ).to.be.lessThan(input.gasToIterate);

    });

    it("Should fail if deleting an inexistent crate", async function () {
      await cratesContract.insertCrate(input.crates[0].id, input.crates[0].size, input.crates[0].strength);
      await expect(cratesContract.deleteCrate(input.crates[1].id)).to.be.reverted;
    });

    it("Should not iterate deleted crates", async function () {
      for (let crate of input.crates) {
        await cratesContract.insertCrate(crate.id, crate.size, crate.strength);
      }

      let expectedIds = input.crates.map(crate => ethers.BigNumber.from(crate.id));

      for (let index of input.deleteIndices) {
        await cratesContract.deleteCrate(input.crates[index].id);
        delete expectedIds[index];
      }

      expectedIds = expectedIds.filter(x => x); // Filter out deleted crates

      const actualIds = (await cratesContract.getCrateIds())
        .map(id => ethers.BigNumber.from(id));
      
      expect(actualIds).to.have.deep.members(expectedIds);
    });

  });
}

module.exports.testCrates = testCrates;
