const { ethers } = require("hardhat");
const { expect } = require("chai");

function testLibMap(subsuiteName, input) {
  describe(subsuiteName, async function () {
    let testShip;
    let paths = new Set();

    before(async function () {
      const TestShip = await ethers.getContractFactory("TestShip");
      testShip = await TestShip.deploy();

      await testShip.deployed();
    });
    
    it('Should be a stateful map', async () => {
      let expectedLocation = "harbor";
    
      for (const step of input.steps) {

        if (step.action == "AddPath") {

          // Action is to add path
          paths.add(step.from + step.to);
          await testShip.addPath(step.from, step.to);

        } else {

          // Action is to travel
          const hasPath = paths.has(expectedLocation + step.to);
          if (hasPath) { expectedLocation = step.to; }

          const tx = testShip.travelAndVerifyResults(
            step.to, 
            hasPath, 
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