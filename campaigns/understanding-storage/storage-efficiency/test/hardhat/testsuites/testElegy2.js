const { ethers } = require("hardhat");
const { expect } = require("chai");

function sum(lines, x) {
  let sum = 0;
  for (let i = 1; i < lines.length; i++) {
    sum += lines[i] * (i * x);
  }
  return ethers.BigNumber.from(sum);
}

function testElegy2(subsuiteName, input) {
  describe(subsuiteName, function () {
    let elegyContract;

    before(async function () {
      const elegyFactory = await ethers.getContractFactory("Elegy2");
      elegyContract = await elegyFactory.deploy(input.lines);

      await elegyContract.deployed();
    });

    it("Should play()", async function () {
      await elegyContract.play(input.nonce);

      const totalSum = await elegyContract.totalSum();
      expect(totalSum).to.equal(sum(input.lines, input.nonce));
    });

    it("Should play() efficiently", async function () {
      const gasMeterFactory = await ethers.getContractFactory("GasMeter");
      const gasMeter = await gasMeterFactory.deploy();
      await gasMeter.deployed();

      const gasSpent = await gasMeter.callStatic.measurePlay(
        input.lines,
        input.nonce
      );

      expect(gasSpent).to.be.lessThan(input.gasLimit);
      
    });
    
  });
}

module.exports.testElegy2 = testElegy2;