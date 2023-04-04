const { expect } = require("chai");
const { ethers } = require("hardhat");

function testSumAllExceptSkip(subsuiteName, input, gasConsumed = []) {
  describe(subsuiteName, function () {
    let challengeContract;
    let meterContract;

    before(async function () {
      const challengeFactory = await ethers.getContractFactory("Challenge");
      const meterFactory = await ethers.getContractFactory("GasMeter");

      challengeContract = await challengeFactory.deploy(input.skip);
      meterContract = await meterFactory.deploy(input.skip);
      
      await challengeContract.deployed();
      await meterContract.deployed();
    });

    it("Should correctly compute the sum", async function () {
      const sum = input.array
        .map(ethers.BigNumber.from)
        .filter(x => !x.eq(input.skip))
        .reduce((acc, current) => acc.add(current), ethers.constants.Zero);
        
      expect(
        await challengeContract.sumAllExceptSkip(input.array)
      ).equal(sum);
    });

    it("Should be more efficient than the reference implementation", async function () {
      const refConsumed = await meterContract.measureReferenceGas(input.array);
      const consumed = await meterContract.measureGas(input.array);

      expect(consumed).to.be.lessThan(refConsumed);
    });

    it(`Should be below the ${input.target} gas consumption target`, async function () {

      const GasMeter = await ethers.getContractFactory("GasMeter");
      const gasMeter = await GasMeter.deploy(input.skip);
      await gasMeter.deployed();

      const consumed = await gasMeter.callStatic.measureGas(input.array);
      
      expect(consumed).to.be.lessThanOrEqual(input.target);

      gasConsumed.push(consumed);
      
    });
  });
}

function testOverflow(subsuiteName, input) {

  describe(subsuiteName, function () {
    let challengeContract;

    before(async function () {
      const challengeFactory 
        = await ethers.getContractFactory("Challenge");

      challengeContract = await challengeFactory.deploy(input.skip);
      await challengeContract.deployed();
    });

    it("Should revert on overflow", async function () {
      await expect(
        challengeContract.sumAllExceptSkip(input.array)
      ).to.be.reverted;
    });
  });

}

module.exports.testSumAllExceptSkip = testSumAllExceptSkip;
module.exports.testOverflow = testOverflow;