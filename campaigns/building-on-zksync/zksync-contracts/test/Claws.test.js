const { expect } = require("chai");
const { Deployer } = require("@matterlabs/hardhat-zksync-deploy");
const { getWallet, LOCAL_RICH_WALLETS } = require("./utils.js");

describe("Claws (Part 1)", function() {

  describe("Public Test 1", function() {
    
    let creator;
    let claws;

    before(async function () {
      creator = getWallet(LOCAL_RICH_WALLETS[0].privateKey);
      const deployer = new Deployer(hre, creator);
      
      claws = await deployer.deploy("Claws", []);
      await claws.waitForDeployment();
    });

    it("Should slash", async function () {
      const targetName = "Dummy Target";

      expect(await claws.isSlashed(targetName)).to.be.false;
      await claws.connect(creator).slash("Dummy Target");
      expect(await claws.isSlashed(targetName)).to.be.true;
    });

    it("Should only obey creator", async function () {
      const other = getWallet(LOCAL_RICH_WALLETS[1].privateKey);

      await expect(claws.connect(other).slash("Dummy Target")).to.be.reverted;
    });

  });
    
});
