const { ethers } = require("hardhat");
const { expect } = require("chai");

// Converts encoded int256 to BigNumber
function intToBN(x) {
  return ethers.BigNumber.from(x).fromTwos(256);
} 

function testArithmetic(subsuiteName, input) {
  describe(subsuiteName, function () {
    before(async function () {
      const arithmeticFactory = await ethers.getContractFactory(
        "Arithmetic"
      );
      arithmetic = await arithmeticFactory.deploy();

      await arithmetic.deployed();
    });

    it("Should add", async () => {
      const x = intToBN(input.addition.x)
      const y = intToBN(input.addition.y);
      expect(await arithmetic.addition(x, y))
        .to.equal(x.add(y));
    });

    it("Should multiply", async () => {
      const x = intToBN(input.multiplication.x);
      const y = intToBN(input.multiplication.y);
      expect(await arithmetic.multiplication(x, y))
        .to.equal(x.mul(y));
    });
   
    it("Should divide (signed)", async () => {
      const x = intToBN(input.signedDivision.x);
      const y = intToBN(input.signedDivision.y);
      expect(await arithmetic.signedDivision(x, y))
        .to.equal(x.div(y));
    });

    it("Should modulo", async () => {
      const x = ethers.BigNumber.from(input.modulo.x);
      const y = ethers.BigNumber.from(input.modulo.y);
      expect(await arithmetic.modulo(x, y))
        .to.equal(x.mod(y));
    });

    it("Should exponentiate (i.e. power)", async () => {
      const x = ethers.BigNumber.from(input.power.x);
      const y = ethers.BigNumber.from(input.power.y);
      expect(await arithmetic.power(x, y))
        .to.equal(x.pow(y));
    });
    
  });
}

module.exports.testArithmetic = testArithmetic;