const { ethers } = require("hardhat");
const { expect } = require("chai");
const { matchers, events } = require("@node-guardians/ng-quests-helpers");

const ROUNDING_ERROR = ethers.utils.parseEther("0.001");

function testElaine(subsuiteName, catData) {

  // Convert integer to big number for safe parsing
  catData.amount = ethers.BigNumber.from(catData.amount.toString());

  describe(subsuiteName, function () {
    let elaine;
    let token;
    let cat;

    let recipient;

    before(async function () {
      recipient = await ethers.getSigner(1);

      let Elaine = await ethers.getContractFactory("Elaine");
      elaine = await Elaine.deploy();

      await elaine.deployed();

      let Token = await ethers.getContractFactory("Token");
      token = await Token.deploy(elaine.address);

      await token.deployed();
    });

    beforeEach(async function () {
      let tx = await elaine.summon(
        recipient.address,
        token.address,
        catData.amount,
        catData.duration
      );

      let catAddress = await events.getArg(tx, "EscrowSummoned(address)", "escrow");
      cat = await ethers.getContractAt("SpiritCat", catAddress);

    });

    it("Should summon new cat", async function () {
      let bytecode = await ethers.provider.getCode(cat.address);
      expect(bytecode.length).to.be.above(2);
      expect(await cat.isActive(), "SpiritCat is not active").to.be.true;
    });

    it("Should deploy cats that hold tokens", async function () {
      expect(await token.balanceOf(cat.address)).to.be.equal(catData.amount);
    });

    it("Should deploy cats with full withdrawal", async function () {
      await network.provider.send("evm_increaseTime", [catData.duration]);

      await expect(cat.connect(recipient).withdraw())
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, recipient.address, catData.amount);
    });

    it("Should deploy cats with correct unlockedBalance()", async function () {

      let divided = catData.amount.div(catData.divisions);

      for (let i = 1; i < catData.divisions; i++) {
        await network.provider.send("evm_increaseTime", [catData.duration / catData.divisions]);
        await ethers.provider.send("hardhat_mine", ["0x1"]);

        expect(await cat.unlockedBalance())
          .to.be.closeTo(divided.mul(i), ROUNDING_ERROR);
      }

      await network.provider.send("evm_increaseTime", [catData.duration / 2]);
      await ethers.provider.send("hardhat_mine", ["0x1"]);

      expect(await cat.unlockedBalance()).to.be.closeTo(catData.amount, ROUNDING_ERROR);
    });

    it("Should deploy cats with partial withdrawal", async function () {
      await network.provider.send("evm_increaseTime", [catData.duration / 2]);

      await expect(cat.connect(recipient).withdraw())
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, recipient.address, matchers.closeTo(catData.amount.div(2), ROUNDING_ERROR));
    });

    it("Should deploy cats that lock after partial withdrawal", async function () {

      await network.provider.send("evm_increaseTime", [catData.duration / catData.divisions]);

      await cat.connect(recipient).withdraw();
      
      expect(await cat.unlockedBalance()).to.equal(0);
      await expect(cat.connect(recipient).withdraw()).to.be.reverted;

      await network.provider.send("evm_increaseTime", [catData.duration]);

      let balance = await cat.balance();
      await expect(cat.connect(recipient).withdraw())
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, recipient.address, balance);
    });

    it("Should deploy cats that only allow recipient to withdraw", async function () {
      await network.provider.send("evm_increaseTime", [catData.duration]);

      let otherSigner = await ethers.getSigner(2);
      await expect(cat.connect(otherSigner).withdraw()).to.be.reverted;
    });

    it("Should dispel cats", async function () {
      await expect(elaine.connect(recipient).dispel(cat.address)).to.be.reverted;

      await expect(elaine.dispel(cat.address))
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, elaine.address, catData.amount);

      expect(await cat.isActive()).to.be.false;
      await expect(cat.connect(recipient).withdraw(), "withdraw() should revert()").to.be.reverted;
      await expect(elaine.dispel(cat.address)).to.be.reverted;
      expect(await cat.unlockedBalance()).to.equal(0);
    });
  });

}

module.exports.testElaine = testElaine;