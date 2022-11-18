const { ethers } = require("hardhat");
const { expect } = require("chai");
const { matchers, events } = require("@ngquests/test-helpers");

const ROUNDING_ERROR = ethers.utils.parseEther("0.001");

function testElaine(input) {

  describe(input.name, function () {
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
        input.amount,
        input.duration
      );

      let catAddress = await events.getArg(tx, "EscrowSummoned(address)", "escrow");
      cat = await ethers.getContractAt("SpiritCat", catAddress);

    });

    it("Should summon new cat", async function () {
      let bytecode = await ethers.provider.getCode(cat.address);
      expect(bytecode.length).to.be.above(2);
    });

    it("Should deploy cats that hold tokens", async function () {
      expect(await token.balanceOf(cat.address)).to.be.equal(input.amount);
    });

    it("Should deploy cats with full withdrawal", async function () {
      await network.provider.send("evm_increaseTime", [input.duration]);

      await expect(cat.connect(recipient).withdraw())
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, recipient.address, input.amount);
    });

    it("Should deploy cats with correct unlockedBalance()", async function () {

      let divided = input.amount.div(input.divisions);

      for (let i = 1; i < input.divisions; i++) {
        await network.provider.send("evm_increaseTime", [input.duration / input.divisions]);
        await ethers.provider.send("hardhat_mine", ["0x1"]);

        expect(await cat.unlockedBalance())
          .to.be.closeTo(divided.mul(i), ROUNDING_ERROR);
      }

      await network.provider.send("evm_increaseTime", [input.duration / 2]);
      await ethers.provider.send("hardhat_mine", ["0x1"]);

      expect(await cat.unlockedBalance()).to.be.closeTo(input.amount, ROUNDING_ERROR);
    });

    it("Should deploy cats with partial withdrawal", async function () {
      await network.provider.send("evm_increaseTime", [input.duration / 2]);

      await expect(cat.connect(recipient).withdraw())
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, recipient.address, matchers.closeTo(input.amount.div(2), ROUNDING_ERROR));
    });

    it("Should deploy cats that lock after partial withdrawal", async function () {

      await network.provider.send("evm_increaseTime", [input.duration / input.divisions]);

      await cat.connect(recipient).withdraw();
      
      expect(await cat.unlockedBalance()).to.equal(0);
      await expect(cat.connect(recipient).withdraw()).to.be.reverted;

      await network.provider.send("evm_increaseTime", [input.duration]);

      let balance = await cat.balance();
      await expect(cat.connect(recipient).withdraw())
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, recipient.address, balance);
    });

    it("Should deploy cats that only allow recipient to withdraw", async function () {
      await network.provider.send("evm_increaseTime", [input.duration]);

      let otherSigner = await ethers.getSigner(2);
      await expect(cat.connect(otherSigner).withdraw()).to.be.reverted;
    });

    it("Should dispel cats", async function () {
      await expect(elaine.connect(recipient).dispel(cat.address)).to.be.reverted;

      await expect(elaine.dispel(cat.address))
        .to.emit(token, "Transfer(address,address,uint256)")
        .withArgs(cat.address, elaine.address, input.amount);

      let bytecode = await ethers.provider.getCode(cat.address);
      expect(bytecode.length).to.be.equal(2);
    });
  });

}

module.exports.testElaine = testElaine;