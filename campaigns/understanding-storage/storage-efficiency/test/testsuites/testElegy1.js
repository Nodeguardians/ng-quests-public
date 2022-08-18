const { ethers } = require("hardhat");
const { expect } = require("chai");

function testElegy1(input) {
  describe(input.name, function () {
    let elegyContract;

    before(async function () {
      const elegyFactory = await ethers.getContractFactory("Elegy1");
      elegyContract = await elegyFactory.deploy();

      await elegyContract.deployed();
    });

    it("Should be cheap to write onto", async function () {
      const estimateGas = await elegyContract.estimateGas.setVerse(
        input.firstVerse,
        input.secondVerse,
        input.thirdVerse,
        input.fourthVerse,
        input.fifthVerse
      );

      expect(estimateGas).to.be.lessThan("100000");
    });

    it("Should should still store data", async function () {
      await elegyContract.setVerse(
        input.firstVerse,
        input.secondVerse,
        input.thirdVerse,
        input.fourthVerse,
        input.fifthVerse
      );

      expect(await elegyContract.firstVerse())
        .to.be.deep.equals(input.firstVerse);
      expect(await elegyContract.secondVerse())
        .to.be.deep.equals(input.secondVerse);
      expect(await elegyContract.thirdVerse())
        .to.be.deep.equals(input.thirdVerse);
      expect(await elegyContract.fourthVerse())
        .to.be.deep.equals(input.fourthVerse);
      expect(await elegyContract.fifthVerse())
        .to.be.deep.equals(input.fifthVerse);

    });
  });
}

module.exports.testElegy1 = testElegy1;