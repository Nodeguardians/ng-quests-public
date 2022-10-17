const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Attacker (Part 1)", function () {
  let simpleGame;
  let attacker;

  beforeEach(async function () {
    const simpleGameFactory = await ethers.getContractFactory("SimpleGameV1");
    simpleGame = await simpleGameFactory.deploy();

    const attackerFactory = await ethers.getContractFactory("Attacker");
    attacker = await attackerFactory.deploy();

    await simpleGame.deployed();
    await attacker.deployed();
  });

  it("Should work", async () => {

    await expect(() =>
      attacker.attack(simpleGame.address, {value: ethers.utils.parseEther("1")})
    ).to.changeEtherBalance(attacker.address, ethers.utils.parseEther("1"));

    expect(await simpleGame.isFinished()).to.be.true;
  });
});
