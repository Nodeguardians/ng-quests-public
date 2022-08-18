const { ethers } = require("hardhat");
const { expect } = require("chai");

function sum(lines, x) {
  let sum = 0;
  for (let i = 1; i < lines.length; i++) {
    sum += lines[i] * (i * x);
  }
  return ethers.BigNumber.from(sum);
}

function testElegy2(input) {
  describe(input.name, function () {
    let elegyContract;

    before(async function () {
      const elegyFactory = await ethers.getContractFactory("Elegy2");
      elegyContract = await elegyFactory.deploy(input.initArray);

      await elegyContract.deployed();
    });

    it("Should work", async function () {
      const estimateGas = await elegyContract.estimateGas.play(input.nonce);
      expect(estimateGas).to.lessThan(input.gasLimit);

      await elegyContract.play(input.nonce);

      const totalSum = await elegyContract.totalSum();
      expect(totalSum).to.equal(sum(input.initArray, input.nonce));
    });
    
  });
}

module.exports.testElegy2 = testElegy2;