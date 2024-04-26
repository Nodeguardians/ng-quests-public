const { ethers } = require("hardhat");
const { expect } = require("chai");

function testChallenge(subsuiteName, input, isPrivate) {
  describe(subsuiteName, function () {
    let ChallengeFactory;
    let challenge;

    beforeEach(async function () {
      ChallengeFactory = await ethers.getContractFactory("Challenge");
      challenge = await ChallengeFactory.deploy();
      await challenge.deployed();
    });

    it("Should romanify numbers", async function () {
      for (let i = 0; i < input.decimal.length; i++) {
        const tx = challenge.romanify(input.decimal[i]);

        if (isPrivate) {
          // If tests are private, hide errors
          try {
            const match = (await tx) === input.roman[i];
            expect(match).to.equal(true);
          } catch (error) {
            throw new Error("Private test failed");
          }
        }
        else {
          // Else, show errors
          expect(await tx).to.equal(input.roman[i]);
        }
      }
    });
  });
}

async function measureChallenge(inputs) {

  gasMeterFactory = await ethers.getContractFactory("GasMeter");
  gasMeter = await gasMeterFactory.deploy();
  await gasMeter.deployed();

  let gasConsumption = 0;
  for (const input of inputs) {
    // Hide errors
    try {
      const estimate = await gasMeter.measureGas(
        input.decimal,
        input.roman
      );
      gasConsumption += parseInt(estimate);
    } catch (error) {
      throw new Error("Unexpected Revert");
    }
  }

  // Take the average of all the gas consumption
  return Math.round(gasConsumption / inputs.length);

}

function testMeasureChallenge(inputs, gasLimit) {
  describe("Gas Efficiency Check", function () {

    it("Should be gas efficient enough", async function () {
      const averageGas = await measureChallenge(inputs);
      expect(averageGas).to.be.below(gasLimit);
    });
    
  });
}

module.exports= {
  measureChallenge,
  testChallenge,
  testMeasureChallenge
};
