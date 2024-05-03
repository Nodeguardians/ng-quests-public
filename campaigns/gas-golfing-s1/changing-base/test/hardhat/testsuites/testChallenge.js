const { expect } = require("chai");

function testChallenge(inputs, isPrivate) {
  let ChallengeFactory;
  let challenge;

  beforeEach(async function () {
    ChallengeFactory = await ethers.getContractFactory("Challenge");
    challenge = await ChallengeFactory.deploy();
    await challenge.waitForDeployment();
  });

  for (const input of inputs) {
    it(`Should convert ${input.name}`, async function () {
      const { inputString, inputBase, outputBase, outputString } = input;

      const tx = challenge.transmuteBase(
        inputString,
        inputBase,
        outputBase
      );

      if (isPrivate) {
        // If tests are private, hide errors
        try {
          expect(await tx).to.equal(outputString);
        } catch (error) {
          throw new Error("Private test failed");
        }
      }
      else {
        // Else, show errors
        const result = await tx;
        expect(result).to.equal(outputString);
      }

    });
  }
}

async function measureChallenge(inputs) {

  gasMeterFactory = await ethers.getContractFactory("GasMeter");
  gasMeter = await gasMeterFactory.deploy();
  await gasMeter.waitForDeployment();

  let gasConsumption = 0;
  for (const input of inputs) {

    const { inputString, outputString, inputBase, outputBase } = input;

    // Hide errors
    try {
      const estimate = await gasMeter.measureGas(
        inputString,
        outputString,
        inputBase,
        outputBase
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
  describe("Efficiency Check", function () {

    it("Should be gas efficient enough", async function () {
      const averageGas = await measureChallenge(inputs);
      expect(averageGas).to.be.below(gasLimit);
    });

    it("Should have compact contract size (< 2kB)", async function () {
      const Challenge = await ethers.getContractFactory("Challenge");
      const challenge = await Challenge.deploy();
      await challenge.waitForDeployment();

      const bytecode = await ethers.provider.getCode(challenge.target);
      const bytecodeSize = (bytecode.length - 2) / 2;
      expect(bytecodeSize).to.be.below(2000);
    });
    
  });
}

module.exports = {
  measureChallenge,
  testChallenge,
  testMeasureChallenge
}
