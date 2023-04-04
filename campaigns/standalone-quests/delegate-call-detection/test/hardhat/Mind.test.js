const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Mind (Part 1)", function () {
  describe("Public Test 1", function() {
    
    let testProbe;
    let mind;
  
    before(async function () {
      const Mind = await ethers.getContractFactory("Mind");
      mind = await Mind.deploy();

      await mind.deployed();

      const TestProbe = await ethers.getContractFactory("TestProbe");
      testProbe = await TestProbe.deploy();

      await testProbe.deployed();
    });

    it("Should detect delegate calls correctly", async () => {
      expect(await testProbe.callStatic.delegateCall(mind.address))
        .to.be.true;
    });

    it("Should detect non-delegate calls correctly", async () => {
      expect(await mind.isDelegateCall()).to.be.false;
    });
  });

});
