const { ethers } = require("hardhat");
const { expect } = require("chai");

const Action = { Travel: 0, AddPath: 1 }

function testLibMap(input) {
  describe(input.name, async function () {
    let testShip;

    before(async function () {
      const TestShip = await ethers.getContractFactory("TestShip");
      testShip = await TestShip.deploy();

      await testShip.deployed();
    });
    
    it('Should work', async () => {
      let expectedLocation = "harbor";
    
      for (const step of input.steps) {

        if (step.action == Action.AddPath) {

          // Action is to add path
          await testShip.addPath(step.from, step.to);

        } else {

          // Action is to travel
          if (step.expected) { expectedLocation = step.to; }

          const tx = testShip.travelAndVerifyResults(
            step.to, 
            step.expected, 
            expectedLocation
          );
          await expect(tx).to.not.be.reverted;

        }
      }
    });

    it('Should avoid storage clashes', async () => {
      expect(await testShip.checkStorageClash(input.slots)).to.be.true;
    });
  });
}

module.exports.testLibMap = testLibMap;
module.exports.Action = Action;