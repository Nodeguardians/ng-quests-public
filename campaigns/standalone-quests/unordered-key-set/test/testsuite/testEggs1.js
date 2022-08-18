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

    it("Should insert and retrieve eggs", async function () {
      for (let egg of input.eggs) {
        await spiderEggsContract.insertEgg(egg.id, egg.size, egg.strength);
      }

      for (let egg of input.eggs) {
        const { size, strength } = await spiderEggsContract.getEgg(egg.id);
        expect(size).to.equal(egg.size);
        expect(strength).to.equal(egg.strength);
      }
    });

    it("Should fail if inserting an existing egg", async function () {
      await spiderEggsContract.insertEgg(input.eggs[0].id, input.eggs[0].size, input.eggs[0].strength);

      await expect(spiderEggsContract.insertEgg(
        input.eggs[0].id, input.eggs[0].size, input.eggs[0].strength
      )).to.be.reverted;
    });

    it("Should fail if retrieving an inexistent egg", async function () {
      await expect(spiderEggsContract.getEgg(input.eggs[0].id)).to.be.reverted;
    });

    it("Should iterate eggs", async function () {
      for (let egg of input.eggs) {
        await spiderEggsContract.insertEgg(egg.id, egg.size, egg.strength);
      }

      const expectedIds = input.eggs
        .map(egg => ethers.BigNumber.from(egg.id));

      const actualIds = await spiderEggsContract.getEggIds();
      expect(actualIds).to.have.deep.members(expectedIds);

    });
  });

}

module.exports.testEggs = testEggs;