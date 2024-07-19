const { ethers } = require("hardhat");
const { expect } = require("chai");
const helpers = require("@nomicfoundation/hardhat-network-helpers");

function testVillageFunding(subsuiteName, inputs) {

  let VFFactory;
  let vf;

  describe(subsuiteName, function () {

    before(async function () {
      VFFactory = await ethers.getContractFactory("VillageFunding");

      for (const villager of inputs.setup.villagers) {
        await helpers.setBalance(villager, ethers.utils.parseEther("1000000"));
      }
    });

    beforeEach(async function () {
      vf = await VFFactory.deploy(
        inputs.setup.villagers, 
        inputs.setup.projects,
        { value: inputs.setup.matchingAmount }
      );

      await vf.deployed();

    });

    it("Should deploy correctly", async function () {
      // 1. Check projects (order doesn't matter)
      const projects = await vf.getProjects();
      expect(projects, "Unexpected projects")
        .to.have.deep.members(inputs.setup.projects);
    });

    it("Should have zero finalFunds before finalizeFunds()", async function () {
      // 1. Process each contribution
      await processContributions();

      // 2. Check final funds == 0
      const finalFunds = await vf.finalFunds(inputs.setup.projects[0]);
      expect(finalFunds).to.equal(0);
    });

    it("Should accept contributions and finalize funds", async function () {

      // 1. Process each contribution
      await processContributions();

      // 2. Finalize funds
      await helpers.time.increase(604801); // 7 days, 1 second
      await vf.finalizeFunds();
      
      // 3. Check final funds of each project
      for (let i = 0; i < inputs.setup.projects.length; i++) {
        const project = inputs.setup.projects[i];
        const finalFunds = await vf.finalFunds(project);
        expect(finalFunds, "Unexpected final funds")
          .to.equal(inputs.expectedFunds[i]);
      }

    });

    it("Should allow withdrawals", async function () {

      // 1. Process each contribution
      await processContributions();

      // 2. Finalize funds
      await helpers.time.increase(604801); // 7 days, 1 second
      await vf.finalizeFunds();
      
      // 3. Test withdraw for each project
      for (let i = 0; i < inputs.setup.projects.length; i++) {
        const project = inputs.setup.projects[i];
        await helpers.setBalance(project, ethers.utils.parseEther("1")); // Supply gas to initiate transaction

        const signer = await ethers.getImpersonatedSigner(project);
        const withdrawTx = await vf.connect(signer).withdraw();

        await expect(withdrawTx)
          .to.changeEtherBalance(project, inputs.expectedFunds[i]);

        expect(
          await vf.finalFunds(project),
          "Final funds should be zero after withdrawal"
        ).to.equal(0);
      }

    });
    
    it("Should reject double contribution", async function () {

      const contribution = inputs.contributions[0];
      const signer = await ethers.getImpersonatedSigner(contribution.villager);

      // 1. Contribute once
      await vf.connect(signer)
        .donate(contribution.project , { value: contribution.amount });

      // 2. Contribute twice (should revert)
      const tx = vf.connect(signer)
        .donate(contribution.project , { value: contribution.amount });
      await expect(tx).to.be.reverted;

    });

    it("Should reject contribution after 7 days", async function () {

      const contribution = inputs.contributions[0];
      const signer = await ethers.getImpersonatedSigner(contribution.villager);

      // 1. Close voting round
      await helpers.time.increase(604801); // 7 days, 1 second

      // 2. Contribute once (should revert)
      const tx = vf.connect(signer)
        .donate(contribution.project , { value: contribution.amount });
      await expect(tx).to.be.reverted;

    });

    it("Should reject contribution to inexistent projects", async function () {

      const contribution = inputs.inexistentProjectContribution;
      const signer = await ethers.getImpersonatedSigner(contribution.villager);

      // 1. Contribute to inexistent project (should revert)
      const tx = vf.connect(signer)
        .donate(contribution.project , { value: contribution.amount });
      await expect(tx).to.be.reverted;

    });

    it("Should reject contribution from non-villager", async function () {

      const contribution = inputs.nonVillagerContribution;
      const signer = await ethers.getImpersonatedSigner(contribution.villager);
        
      await helpers.setBalance(contribution.villager, ethers.utils.parseEther("1")); // Supply gas to initiate transaction

      // 1. Contribute (should revert)
      const tx = vf.connect(signer)
        .donate(contribution.project , { value: contribution.amount });
      await expect(tx).to.be.reverted;

    });

    it("Should reject finalizeFunds() before 7 days", async function () {

      // 1. Process each contribution
      await processContributions();

      // 2. Finalize funds before 7 days (should revert)
      const tx = vf.finalizeFunds();
      await expect(tx).to.be.reverted;

    });

    it("Should reject invalid withdrawals", async function () {

      // 1. Process each contribution
      await processContributions();

      // 2. Finalize funds
      await helpers.time.increase(604801); // 7 days, 1 second
      await vf.finalizeFunds();

      // 3. Test invalid withdrawal from non-project (should revert)
      const withdrawTx1 = vf.withdraw();
      await expect(withdrawTx1).to.be.reverted;

      // 4. Test double withdrawal (should revert)

      // Use project with smaller funds
      let project;
      if (inputs.expectedFunds[0] < inputs.expectedFunds[0]) {
          project = inputs.setup.projects[0];
      } else {
          project = inputs.setup.projects[1];
      }
      
      const signer = await ethers.getImpersonatedSigner(project);
      await helpers.setBalance(project, ethers.utils.parseEther("1")); // Supply gas to initiate transaction

      await vf.connect(signer).withdraw();
      const withdrawTx2 = vf.connect(signer).withdraw();
      await expect(withdrawTx2).to.be.reverted;

    });

    it("Should block reentrancy attack on withdrawal", async function () {
        
        // 1. Process each contribution
        await processContributions();
  
        // 2. Finalize funds
        await helpers.time.increase(604801); // 7 days, 1 second
        await vf.finalizeFunds();
  
        // 3. Test reentrancy attack on withdrawal
        const { deployedBytecode } = require(
          "../../../artifacts/contracts/test/ReentrancyAttacker.sol/ReentrancyAttacker.json"
        );

        // Use project with smaller funds
        let project;
        if (inputs.expectedFunds[0] < inputs.expectedFunds[0]) {
            project = inputs.setup.projects[0];
        } else {
            project = inputs.setup.projects[1];
        }
        
        await helpers.setCode(project, deployedBytecode);

        const signer = await ethers.getImpersonatedSigner(project);
        await helpers.setBalance(project, ethers.utils.parseEther("1")); // Supply gas to initiate transaction

        const withdrawTx = vf.connect(signer).withdraw();
        await expect(withdrawTx).to.be.reverted;

    });

    async function processContributions() {
      for (const contribution of inputs.contributions) {
        const signer = await ethers.getImpersonatedSigner(contribution.villager);
        await vf.connect(signer)
          .donate(contribution.project , { value: contribution.amount });
      }
    }
  });
}

module.exports.testVillageFunding = testVillageFunding;