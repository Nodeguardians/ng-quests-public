const { expect } = require("chai");

function testChallenge(subsuiteName, input, isPrivate) {
  describe(subsuiteName, function () {
    let ChallengeFactory;
    let challenge;

    before(async function () {
      ChallengeFactory = await ethers.getContractFactory("Challenge");
      challenge = await ChallengeFactory.deploy();
      await challenge.waitForDeployment();
    });

    it(`Should record boards`, async function () {
      for (const entry of input) {
        const tx = challenge.recordBoard(entry.id, entry.board);
        if (isPrivate) {
          // If tests are private, hide errors
          try {
            await tx;
          } catch (error) {
            throw new Error("Private test failed");
          }
        } else {
          // Else, show errors
          await tx;
        }
      }
    });

    it("Should get boards", async function () {
      for (const entry of input) {
        const tx = challenge.getBoard(entry.id);

        if (isPrivate) {
          // If tests are private, hide errors
          try {
            expect(await tx).to.equal(entry.board);
          } catch (error) {
            throw new Error("Private test failed");
          }
        } else {
          // Else, show errors
          expect(await tx).to.equal(entry.board);
        }
      }
    });
  });
}

async function measureChallenge(inputs) {
  gasMeterFactory = await ethers.getContractFactory("GasMeter");
  gasMeter = await gasMeterFactory.deploy();
  await gasMeter.waitForDeployment();

  let gasConsumption = 0;
  for (const input of inputs) {

    // Hide errors
    try {
      await gasMeter.measureGas(input);
      gasConsumption += parseInt(await gasMeter.output());
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

    it("Should have compact contract size (< 4kB)", async function () {
      const Challenge = await ethers.getContractFactory("Challenge");
      const challenge = await Challenge.deploy();
      await challenge.waitForDeployment();

      const bytecode = await ethers.provider.getCode(challenge.target);
      const bytecodeSize = (bytecode.length - 2) / 2;
      expect(bytecodeSize).to.be.below(4000);
    });
  });
}

module.exports = {
  measureChallenge,
  testChallenge,
  testMeasureChallenge,
};
