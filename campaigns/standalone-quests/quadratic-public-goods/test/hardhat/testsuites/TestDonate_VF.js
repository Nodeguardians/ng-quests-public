const { ethers } = require("hardhat");
const { expect } = require("chai");
const { 
  time, 
  setBalance 
} = require("@nomicfoundation/hardhat-network-helpers");

function TestDonate_VF(subsuiteName, input) {
  describe(subsuiteName, function () {
    before(async function () {
      VFFactory = await ethers.getContractFactory("VillageFunding");
    });

    it("Test donation 1", async () => {
      await deployAndCheck(input[0]);
    });

    it("Test donation 2", async () => {
      await deployAndCheck(input[1]);
    });
  });
}

async function deployAndCheck(input) {
  vf = await VFFactory.deploy(
    input.setup.villagers, 
    input.setup.projects, 
    input.setup.voteDuration
  );  
  
  await vf.deployed();

  let totalAmount = 0n;
  for (let i = 0; i < input.steps.length; ++i) {
    await time.increase(input.steps[i].donateTime); 
    setBalance(input.steps[i].donor, 20n**18n);
    const donor = await ethers.getImpersonatedSigner(
      input.steps[i].donor
    );

    if (input.steps[i].shouldFail) {
      await expect(vf.connect(donor).donate({
        value: BigInt(input.steps[i].amount)
      })).to.be.reverted;
      continue;
    }

    await vf.connect(donor).donate({
      value: BigInt(input.steps[i].amount)
    });

    totalAmount += BigInt(input.steps[i].amount);
  }

  for (let i = 0; i < input.setup.villagers.length; ++i) {
    let actualVotePower = await vf.getVotePower(
      input.setup.villagers[i]
    );
    const delta = BigInt(Math.floor(
      input.votePower[i] * 0.05
    ));
    expect(actualVotePower).to.be.closeTo(
      input.votePower[i],
      delta,
      "Wrong vote power"
    );
  }

  expect(await ethers.provider.getBalance(vf.address)).to.be.equal(
    totalAmount, 
    "Wrong balance"
  );
}

module.exports.TestDonate_VF = TestDonate_VF;