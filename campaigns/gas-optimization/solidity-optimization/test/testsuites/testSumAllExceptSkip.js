const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCopyArray(input, gasConsumed = []) {
  describe(input.name, function () {
    let challengeContract;
    let referenceContract;

    before(async function () {
      const referenceFactory = await ethers.getContractFactory("Reference");
      const challengeFactory = await ethers.getContractFactory("Challenge");

      referenceContract = await referenceFactory.deploy(input.skip);
      challengeContract = await challengeFactory.deploy(input.skip);
      await referenceContract.deployed();
      await challengeContract.deployed();
    });

    const sum = input.array.reduce((acc, current) => {
      const value = ethers.BigNumber.from(current);

      if (value.eq(input.skip) == false) {
        acc = acc.add(value);
      }

      return acc;
    }, ethers.constants.Zero);

    const overflow = sum.gt(ethers.constants.MaxUint256);

    if (overflow) {
      it("Should revert on overflow", async function () {
        await expect(challengeContract.sumAllExceptSkip(input.array)).to.be
          .reverted;
      });
    } else {
      it("Should correctly compute the sum", async function () {
        const expected = input.array.reduce((sum, current) => {
          if (current != input.skip) {
            return sum + current;
          }
          return sum;
        }, 0);

        expect(await challengeContract.sumAllExceptSkip(input.array)).equal(
          expected
        );
      });

      it("Should be more efficient than the reference implementation", async function () {
        const referenceConsumed =
          await referenceContract.estimateGas.referenceSumAllExceptSkip(
            input.array
          );
        const consumed = await challengeContract.estimateGas.sumAllExceptSkip(
          input.array
        );

        expect(consumed).to.be.lessThan(referenceConsumed);
      });

      it(`Should be below the ${input.target} gas consumption target`, async function () {
        const consumed =
          (await challengeContract.estimateGas.sumAllExceptSkip(input.array)) -
          21000;
        expect(consumed).to.be.lessThanOrEqual(input.target);

        gasConsumed.push(consumed);
      });
    }
  });
}

module.exports.testCopyArray = testCopyArray;
