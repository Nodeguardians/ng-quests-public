const { expect } = require("chai");
const hre = require("hardhat");
const {
  getWallet,
  LOCAL_RICH_WALLETS,
  getProvider,
  sendTransaction
} = require("../utils.js");
const { Deployer } = require("@matterlabs/hardhat-zksync-deploy");
const zksync = require("zksync-ethers");

function testSummonerAccount(subsuiteName, input) {
  describe(subsuiteName, function () {

    let summoner;
    let creature;

    let deployerWallet;
    let summonerAccount;

    let boxArtifact;
    let boxHash;
    let box;
    let whitelistedBox;
    let spoofer;

    let abiCoder;
    let provider

    before(async function () {
      abiCoder = new ethers.AbiCoder();
      provider = getProvider();

      summoner = getWallet(LOCAL_RICH_WALLETS[1].privateKey);
      creature = getWallet(LOCAL_RICH_WALLETS[2].privateKey);

      deployerWallet = getWallet(LOCAL_RICH_WALLETS[0].privateKey);

      const accountDeployer = new Deployer(hre, deployerWallet, "createAccount");
      const deployer = new Deployer(hre, deployerWallet);

      summonerAccount = await accountDeployer.deploy(
        "SummonerAccount",
        [ summoner.address, creature.address ]
      );

      await summonerAccount.waitForDeployment();
      
      boxArtifact = await deployer.loadArtifact("Box");
      boxHash = zksync.utils.hashBytecode(boxArtifact.bytecode);
      box = await deployer.deploy("Box", [ 0 ]);
      box.waitForDeployment();
      
      spoofer = await deployer.deploy("TransactionSpoofer", [ ]);
      await spoofer.waitForDeployment();
    });

    it("Should receive ETH", async function () {
      await deployerWallet.sendTransaction({
        to: summonerAccount.target,
        value: ethers.parseEther("1")
      });
    });

    it("Should let summoner call any address", async function () {

      await sendTransaction(
        summonerAccount.target,
        box.target,
        "set(uint256)",
        [1],
        summoner
      );

      expect(await box.value()).to.equal(1);

    });

    it("Should let summoner deploy contracts", async function () {

      await sendTransaction(
        summonerAccount.target, 
        zksync.utils.CONTRACT_DEPLOYER_ADDRESS, 
        "create2(bytes32,bytes32,bytes)", 
        [
          input.salt,
          boxHash, 
          abiCoder.encode(["uint256"], [input.seed])
        ],
        summoner
      );
    
      const whitelistedBoxAddr = zksync.utils.create2Address(
        summonerAccount.target,
        boxHash,
        input.salt,
        abiCoder.encode(["uint256"], [input.seed])
      );

      whitelistedBox = await ethers.getContractAt( 
        "Box",
        whitelistedBoxAddr
      );

      expect(await provider.getCode(whitelistedBox.target)).to.equal(
        boxArtifact.bytecode,
        "Unexpected deployed bytecode"
      );

      expect(await whitelistedBox.value()).to.equal(input.seed);
    });

    it("Should whitelist deployed contracts", async function () {
      expect(
        await summonerAccount.isWhitelisted(whitelistedBox.target)
      ).to.be.true;
    })

    it("Should not let creature call non-whitelisted addresses", async function () {
      const tx = sendTransaction(
        summonerAccount.target,
        box.target,
        "add(uint256)",
        [1],
        creature
      );

      await expect(tx).to.be.reverted;
    })

    it("Should let creature call whitelisted addresses", async function () {
      await sendTransaction(
        summonerAccount.target,
        whitelistedBox.target,
        "set(uint256)",
        [ input.seed + 11 ],
        creature
      );

      expect(await whitelistedBox.value()).to.equal(input.seed + 11);
    })

    it("Should reject other signers", async function () {
      const other = getWallet(LOCAL_RICH_WALLETS[3].privateKey);

      const tx = sendTransaction(
        summonerAccount.target,
        whitelistedBox.target,
        "set(uint256)",
        [ 0 ],
        other
      );

      await expect(tx).to.be.reverted;
    });

  
    it("Should only be callable by bootloader", async function () {
      const spoofTx1 = spoofer.spoofValidateTransaction(summonerAccount.target);
      await expect(spoofTx1).to.be.revertedWith("NOT_BOOTLOADER");

      const spoofTx2 = spoofer.spoofPayForTransaction(summonerAccount.target);
      await expect(spoofTx2).to.be.revertedWith("NOT_BOOTLOADER");

      const spoofTx3 = spoofer.spoofValidateTransaction(summonerAccount.target);
      await expect(spoofTx3).to.be.revertedWith("NOT_BOOTLOADER");
      
    });
  });
}

module.exports.testSummonerAccount = testSummonerAccount;