const { expect } = require("chai");
const { Deployer } = require("@matterlabs/hardhat-zksync-deploy");
const { getWallet, LOCAL_RICH_WALLETS } = require("./utils.js");

describe("Senses (Part 2)", function() {

  describe("Public Test 1", function() {

    let deployer;

    let ally;
    let enemy;

    let senses;

    before(async function () {
      deployer = new Deployer(
        hre, 
        getWallet(LOCAL_RICH_WALLETS[0].privateKey)
      );

      ally = await deployer.deploy("Ally", []);
      await ally.waitForDeployment();

      enemy = await deployer.deploy("Enemy", []);
      await enemy.waitForDeployment();
    });

    beforeEach(async function () {
      let firstEnemy = await deployer.deploy("Enemy", []);
      await firstEnemy.waitForDeployment();

      senses = await deployer.deploy("Senses", [ firstEnemy.target ]);
      await senses.waitForDeployment();
    });

    it("Should detect enemy", async function () {
      expect(await senses.detect(enemy.target)).to.be.true;
    });

    it("Should ignore ally", async function () {
      expect(await senses.detect(ally.target)).to.be.false;
    });
  });
    
});
