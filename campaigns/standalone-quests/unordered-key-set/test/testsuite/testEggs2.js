const { expect } = require("chai");
const { ethers } = require("hardhat");

function testEggs(input) {
  describe(input.name, function () {
    let spiderEggsContract;

    beforeEach(async function () {
      const spiderEggsFactory = await ethers.getContractFactory("SpiderEggs");
      spiderEggsContract = await spiderEggsFactory.deploy();

      await spiderEggsContract.deployed();
    });

    it("Should delete eggs", async function () {
      for (let egg of input.eggs) {
        await spiderEggsContract.insertEgg(egg.id, egg.size, egg.strength);
      }

      // Check eggs have been deleted
      for (let index of input.deleteIndices) {
        await spiderEggsContract.deleteEgg(input.eggs[index].id);
        await expect(spiderEggsContract.getEgg(input.eggs[index].id)).to.be.reverted;
      }

    });

    it("Should be gas efficient", async function () {
      for (let egg of input.eggs) {
        await spiderEggsContract.insertEgg(
          egg.id, egg.size, egg.strength, 
          { gasLimit: input.gasPerInsert }
        );
      }

      for (let index of input.deleteIndices) {
        await spiderEggsContract.deleteEgg(
          input.eggs[index].id,
          { gasLimit: input.gasPerDelete }
        );
      }

      expect(
        await spiderEggsContract.estimateGas.getEggIds()
        ).to.be.lessThan(input.gasToIterate);

    });

    it("Should fail if deleting an inexistent egg", async function () {
      await spiderEggsContract.insertEgg(input.eggs[0].id, input.eggs[0].size, input.eggs[0].strength);
      await expect(spiderEggsContract.deleteEgg(input.eggs[1].id)).to.be.reverted;
    });

    it("Should not iterate deleted eggs", async function () {
      for (let egg of input.eggs) {
        await spiderEggsContract.insertEgg(egg.id, egg.size, egg.strength);
      }

      let expectedIds = input.eggs.map(egg => ethers.BigNumber.from(egg.id));

      for (let index of input.deleteIndices) {
        await spiderEggsContract.deleteEgg(input.eggs[index].id);
        delete expectedIds[index];
      }

      expectedIds = expectedIds.filter(x => x); // Filter out deleted eggs

      const actualIds = await spiderEggsContract.getEggIds();
      expect(actualIds).to.have.deep.members(expectedIds);
    });

  });
}

module.exports.testEggs = testEggs;