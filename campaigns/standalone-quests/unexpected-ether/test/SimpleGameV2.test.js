const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("SimpleGameV2 (Part 2)", function () {
  let simpleGame;
  let attacker;

  beforeEach(async function () {
    const simpleGameFactory = await ethers.getContractFactory("SimpleGameV2");
    simpleGame = await simpleGameFactory.deploy();

    const attackerFactory = await ethers.getContractFactory("Attacker");
    attacker = await attackerFactory.deploy();

    await simpleGame.deployed();
    await attacker.deployed();
  });

  it("Should be immune to attacker", async () => {
    await expect(
      attacker.attack(simpleGame.address, { value: ethers.utils.parseEther("1") })
    ).to.be.revertedWith("Condition not satisfied");
  });

  it("Should only accept 0.1 ETH each deposit", async () => {
    await expect(
      simpleGame.deposit({
        value: ethers.utils.parseEther("0.1"),
      })
    ).to.be.not.reverted;

    await expect(
      simpleGame.deposit({
        value: ethers.utils.parseEther("0.2"),
      })
    ).to.be.revertedWith("Must deposit 0.1 Ether");
  });

  it("Should not claimable before the condition is satisfied", async () => {
    for (let _ = 0; _ < 9; _++) {
      await simpleGame.deposit({
        value: ethers.utils.parseEther("0.1"),
      });
    }

    await expect(simpleGame.claim()).to.be.revertedWith(
      "Condition not satisfied"
    );

    await simpleGame.deposit({
      value: ethers.utils.parseEther("0.1"),
    });

    await expect(simpleGame.claim()).to.be.not.reverted;
  });

  it("should finish the game after claimed", async () => {
    for (let _ = 0; _ < 10; _++) {
      await simpleGame.deposit({
        value: ethers.utils.parseEther("0.1"),
      });
    }

    await simpleGame.claim();

    const isFinished = await simpleGame.isFinished();
    expect(isFinished).to.be.true;

    await expect(
      simpleGame.deposit({ value: ethers.utils.parseEther("0.1") })
    ).to.be.revertedWith("The game is over");
  });
});