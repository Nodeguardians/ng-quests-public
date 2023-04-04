const { ethers } = require("hardhat");
const { expect } = require("chai");

function testElegy1(subsuiteName, input) {
  describe(subsuiteName, function () {
    let elegyContract;

    beforeEach(async function () {
      const elegyFactory = await ethers.getContractFactory("Elegy1");
      elegyContract = await elegyFactory.deploy();

      await elegyContract.deployed();
    });

    it("Should setVerse()", async function () {
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

    it("Should setVerse() efficiently", async function () {

      const gasMeterFactory = await ethers.getContractFactory("GasMeter");
      const gasMeter = await gasMeterFactory.deploy();
      await gasMeter.deployed();

      const gasSpent = await gasMeter.callStatic.measureSetVerse(
        input.firstVerse,
        input.secondVerse,
        input.thirdVerse,
        input.fourthVerse,
        input.fifthVerse
      );

      expect(gasSpent).to.be.lessThan(72000);

    });
  });
}

module.exports.testElegy1 = testElegy1;