const { expect } = require("chai");
const hre = require("hardhat");
const {
  advanceTime,
  getProvider,
  getWallet,
  setTime,
  LOCAL_RICH_WALLETS,
} = require("../utils.js");
const { Deployer } = require("@matterlabs/hardhat-zksync-deploy");
const zksync = require("zksync-ethers");

function testPaymaster(subsuiteName, input) {
  describe(subsuiteName, function () {

    let lunarPaymaster;
    let user;
    let userId;
    let box;

    let provider;
    let deployer;
    let deployerWallet;

    before(async function () {
      provider = getProvider();

      deployerWallet = getWallet(LOCAL_RICH_WALLETS[0].privateKey);
      deployer = new Deployer(hre, deployerWallet);

      lunarPaymaster = await deployer.deploy(
        "LunarPaymaster", [ ]
      );
      await lunarPaymaster.waitForDeployment();

      userId = 1;

      box = await deployer.deploy("Box", [ 0 ]);
      await box.waitForDeployment();

      await advanceTime(180000); // Realistically, time should be around 2020s
      await setTime(input.nightTime);
    });
    
    beforeEach(async function () {
      box = await deployer.deploy("Box", [ 0 ]);
      await box.waitForDeployment();

      user = getWallet(LOCAL_RICH_WALLETS[userId++].privateKey);
    });

    async function getTxOptions(gasLimitInWei, isFullMoon = false) {
      const gasPrice = await provider.getGasPrice();
      const gasLimit = gasLimitInWei / gasPrice;

      const innerInput = (isFullMoon) 
        ? ethers.toUtf8Bytes("I CALL FORTH THE FULL MOON") 
        : new Uint8Array();

      paymasterParams = zksync.utils.getPaymasterParams(
        lunarPaymaster.target,
        { type: "General", innerInput }
      );

      return {
        maxPriorityFeePerGas: BigInt(0),
        maxFeePerGas: gasPrice,
        gasLimit: gasLimit,
        customData: {
          gasPerPubdata: zksync.utils.DEFAULT_GAS_PER_PUBDATA_LIMIT,
          paymasterParams,
        },
      };
    }

    it("Should receive ETH", async function () {
      await deployerWallet.sendTransaction({
        to: lunarPaymaster.target,
        value: ethers.parseEther("1")
      });
    });

    it("Should fund transactions in the night", async function () {
      const gasLimitInWei = ethers.parseEther(input.mediumGasLimit);
      const txOptions = await getTxOptions(gasLimitInWei);
      await box.connect(user).set(11, txOptions);

      expect(await box.value()).to.equal(11);
    });

    it("Should fund transactions up to the nightly limit", async function () {
      const gasLimitInWei = ethers.parseEther(input.smallGasLimit);
      const txOptions = await getTxOptions(gasLimitInWei);

      const nightlyLimit = ethers.parseEther("0.01");

      // Use up as much of the nightly limit as possible
      let totalTapped = 0n;
      while (totalTapped + gasLimitInWei < nightlyLimit) {

        await box.connect(user).set(11, txOptions);
        
        const newTapped = await lunarPaymaster.tappedAmount(user.address);
        expect(newTapped - totalTapped).to.equal(gasLimitInWei);
        
        totalTapped = newTapped;
      }

      // At this point, the user has spent nearly the entire nightly limit
      // The next transaction should fail.
      const tx = box.connect(user).set(11, txOptions);
      await expect(tx).to.be.reverted;
    });

    it("Should have new tapped amount every night", async function () {
      const txOptions = await getTxOptions(ethers.parseEther(input.largeGasLimit));
      await box.connect(user).set(11, txOptions);

      // Set to next night ( +24hrs )
      await setTime(input.nightTime);

      expect(
        await lunarPaymaster.tappedAmount(user.address)
      ).to.equal(0);

      await box.connect(user).set(11, txOptions);
      expect(await box.value()).to.equal(11);
    });

    it("Should not fund transactions in the day", async function () {
      // Set to daytime
      await setTime(input.dayTime);

      const gasLimit = ethers.parseEther(input.mediumGasLimit);
      const txOptions = await getTxOptions(gasLimit);
      
      const tx = box.connect(user).set(11, txOptions);
      await expect(tx).to.be.reverted;
    });

    it("Should fund a full-moon transaction", async function () {
      // Set to night time
      await setTime(input.nightTime);

      const gasLimit = ethers.parseEther(input.mediumGasLimit) * 2n;
      const txOptions = await getTxOptions(gasLimit, true);
      
      await box.connect(user).set(11, txOptions);
      expect(await box.value()).to.equal(11);
    });

    it("Should reject transactions after a full-moon", async function () {
      const gasLimit = ethers.parseEther(input.largeGasLimit) * 2n;
      const txOptions = await getTxOptions(gasLimit, true);
      
      await box.connect(user).set(1, txOptions);

      const badTx1 = box.connect(user).set(11, txOptions);
      await expect(badTx1).to.be.reverted;

      // Set to 28th night (+(24 * 28) hrs)
      await advanceTime(28);

      const badTx2 = box.connect(user).set(11, txOptions);
      await expect(badTx2).to.be.reverted;

      // Set to 29th night (+24 hrs)
      await advanceTime(2);
      await box.connect(user).set(11, txOptions);
      expect(await box.value()).to.equal(11);
    });

    it("Should only be callable by bootloader", async function () {
      const spoofer = await deployer.deploy("TransactionSpoofer", [ ]);
      await spoofer.waitForDeployment();

      const spoofTx1 = spoofer.connect(user)
        .spoofValidateAndPayForPaymasterTransaction(lunarPaymaster.target);
      await expect(spoofTx1).to.be.revertedWith("NOT_BOOTLOADER");

      const spoofTx2 = spoofer.connect(user)
        .spoofPostTransaction(lunarPaymaster.target);
      await expect(spoofTx2).to.be.revertedWith("NOT_BOOTLOADER");
    });
  });
}

module.exports.testPaymaster = testPaymaster;