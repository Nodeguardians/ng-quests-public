const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Shadeling", function () {
  let shadelingContract;
  let attackerContract;

  before(async () => {
    const shadelingFactory = await ethers.getContractFactory("Shadeling");
    shadelingContract = await shadelingFactory.deploy();

    const attackerFactory = await ethers.getContractFactory("Attacker");
    attackerContract = await attackerFactory.deploy();

    await shadelingContract.deployed();
    await attackerContract.deployed();
  });

  it("should predictable", async () => {
    await attackerContract.predict(shadelingContract.address);

    const isPredicted = await shadelingContract.isPredicted();

    expect(isPredicted).to.be.true;
  });
});
