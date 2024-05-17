const { expect } = require("chai");
const { Deployer } = require("@matterlabs/hardhat-zksync-deploy");
const { getProvider, getWallet, LOCAL_RICH_WALLETS } = require("../utils.js");
const zksync = require("zksync-ethers");

function testLungs(subsuiteName, artifactName) {
  describe(subsuiteName, function() {

    let deployer;
    let lungs;

    let provider;
    let soundArtifact; // Artifact of the contract to be deployed
    let soundHash; // Hash of the contract to be deployed

    before(async function () {
      deployer = new Deployer(
        hre, 
        getWallet(LOCAL_RICH_WALLETS[0].privateKey)
      );
      
      provider = getProvider();
      soundArtifact = await deployer.loadArtifact(artifactName);
      soundHash = zksync.utils.hashBytecode(soundArtifact.bytecode);
    });

    beforeEach(async function () {
      lungs = await deployer.deploy(
        "Lungs", 
        [], 
        {}, 
        [soundArtifact.bytecode] // FactoryDeps: Publish soundArtifact to L1
      );

      await lungs.waitForDeployment();
    });

    it("Should deploy contracts", async function () {

      await lungs.roar(soundHash);
      const soundAddress = await lungs.lastRoar();

      expect(await provider.getCode(soundAddress))
        .to.equal(soundArtifact.bytecode);

    });

    it("Should deploy multiple contracts", async function () {
      let lastSoundAddress = "";
      for (let i = 0; i < 2; ++i) {
        await lungs.roar(soundHash);
        const soundAddress = await lungs.lastRoar();
        
        expect(soundAddress).to.not.equal(lastSoundAddress);

        expect(await provider.getCode(soundAddress))
          .to.equal(soundArtifact.bytecode);

        lastSoundAddress = soundAddress;
      }
    });


  });
}

module.exports = {
  testLungs
};