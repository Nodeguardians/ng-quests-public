const { ethers } = require("hardhat");
const { expect } = require("chai");
const { events } = require("@node-guardians/ng-quests-helpers");

describe("Elaine (Part 2)", function () {

  describe("Public Test 1", function () {
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

      let tx = await elaine.summon(
        recipient.address,
        token.address,
        ethers.utils.parseEther("1"),
        100000
      );

      let catAddress = await events.getArg(tx, "EscrowSummoned(address)", "escrow");
      cat = await ethers.getContractAt("SpiritCat", catAddress);

    });

    it("Should summon minimal proxy cat", async function () {
      let bytecode = await ethers.provider.getCode(cat.address);
      expect(bytecode.length).to.be.lessThanOrEqual(92);
    });
  });

});