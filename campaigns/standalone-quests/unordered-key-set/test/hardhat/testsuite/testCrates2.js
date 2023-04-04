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

    it("Should delete crates", async function () {
      for (let crate of crates) {
        await cratesContract.insertCrate(
          crate.id, crate.size, crate.strength);
      }

      // Check crates have been deleted
      for (let id of input.deleteIds) {
        await cratesContract.deleteCrate(id);
        await expect(cratesContract.getCrate(id)).to.be.reverted;
      }

    });

    it("Should be gas efficient", async function () {

      const gasMeterFactory = await ethers.getContractFactory("GasMeter");
      gasMeter = await gasMeterFactory.deploy(cratesContract.address);
      await gasMeter.deployed();

      for (let crate of crates) {
        const tx = gasMeter.insertCrate(
          crate.id, crate.size, crate.strength, input.gasPerInsert
        );
        await expect(tx).to.not.be.reverted;
      }

      for (let id of input.deleteIds) {
        const tx = gasMeter.deleteCrate(
          id, input.gasPerDelete
        );
        await expect(tx).to.not.be.reverted;
      }

      const tx = gasMeter.getCrateIds(input.gasToIterate);
      await expect(tx).to.not.be.reverted;

    });

    it("Should fail if deleting an inexistent crate", async function () {
      await cratesContract.insertCrate(crates[0].id, crates[0].size, crates[0].strength);
      await expect(cratesContract.deleteCrate(crates[1].id)).to.be.reverted;
    });

    it("Should not iterate deleted crates", async function () {
      for (let crate of crates) {
        await cratesContract.insertCrate(crate.id, crate.size, crate.strength);
      }

      let expectedIds = crates.map(crate => ethers.BigNumber.from(crate.id));

      for (let id of input.deleteIds) {
        await cratesContract.deleteCrate(id);
        expectedIds = expectedIds.filter(x => !x.eq(id));
      }

      const actualIds = await cratesContract.getCrateIds();
      expect(actualIds).to.have.deep.members(expectedIds);
    });

  });
}

module.exports.testCrates = testCrates;