const { ethers } = require("hardhat");
const { expect } = require("chai");

function TestValidDeployment_VF(subsuiteName, input) {
  describe(subsuiteName, function () {
    before(async function () {
      VFFactory = await ethers.getContractFactory("VillageFunding");
    });

    it("Valid deployment", async () => {
      vf = await VFFactory.deploy(
        input[0].villagers, 
        input[0].projects, 
        input[0].voteDuration
      );  
  
      await vf.deployed();

      expect(await vf.getProjects())
        .to.be.deep.equal(input[0].projects, "Wrong projects");
    });
  });
}

function TestInvalidDeployment_VF(subsuiteName, input, tests) {
  describe(subsuiteName, function () {
    before(async function () {
      VFFactory = await ethers.getContractFactory("VillageFunding");
    });

    for (let i = 1; i < input.length; ++i) {
      it(tests[i-1], async () => {
        await expect(VFFactory.deploy(
          input[i].villagers, 
          input[i].projects, 
          input[i].voteDuration
        )).to.be.reverted;
      });
    }
  });
}

module.exports.TestValidDeployment_VF = TestValidDeployment_VF;
module.exports.TestInvalidDeployment_VF = TestInvalidDeployment_VF;