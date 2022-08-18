const { ethers } = require("hardhat");
const { expect } = require("chai");
const { deploy } = require("../../scripts/deploy.js");

function testSuit(input) {
  describe(input.name, function () {
    // Keccak-256 hash of OpenZeppelin's basic proxy contract bytecode

    let suit;
    let signers;

    let LASER_HASH = ethers.utils.keccak256(ethers.utils.toUtf8Bytes("KSHAAAKKKKKK!!!"));

    before(async function () {
      signers = await ethers.getSigners();
      suit = await deploy(input.threshold);
    });

    it("Should work", async function () {
      for (let step of input.steps) {
        switch (step.action) {
          case "offer":
            await suit.connect(signers[step.src])
              .offerPower({ value: step.value });
            break;

          case "getEnergy":
            expect(
              await suit.energy(signers[step.src].address)
            ).to.equal(step.expectedValue);
            break;

          case "getTotalEnergy":
            expect(await suit.totalEnergy())
              .to.equal(step.expectedValue);
            break;

          case "fireLaser":
            if (step.reverted) {
              await expect(suit.fireLaser()).to.be.reverted;
            } else {
              expect(await suit.fireLaser()).to.be.equal(LASER_HASH);
            }
            break;

        }

      }
    });
  });
}

module.exports.testSuit = testSuit;