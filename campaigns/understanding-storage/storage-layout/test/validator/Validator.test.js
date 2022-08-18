const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Temple", function () {

  let validator;
  let attacker;
  let user;

  before(async () => {
    let Validator = await ethers.getContractFactory("Validator");
    validator = await Validator.deploy();

    await validator.deployed();

    user = await ethers.getSigner(1);

    let Attacker = await ethers.getContractFactory("Attacker");
    attacker = await Attacker.connect(user).deploy();

    await attacker.deployed();
  });

  it("Should be able to find Main Hall", async function () {
    await validator.connect(user).deploy(1);
    
    await attacker.findMainHall(
      await validator.deployments(user.address, 1)
    );

    expect(await validator.test(user.address, 1)).to.be.true;
  });

  it("Should be able to find Garden", async function () {
    await validator.connect(user).deploy(2);
    
    await attacker.findGarden(
      await validator.deployments(user.address, 2)
    );

    expect(await validator.test(user.address, 2)).to.be.true;
  });

  it("Should be able to find Garden", async function () {
    await validator.connect(user).deploy(3);
    
    await attacker.findChamber(
      await validator.deployments(user.address, 3)
    );

    expect(await validator.test(user.address, 3)).to.be.true;
  });

});
