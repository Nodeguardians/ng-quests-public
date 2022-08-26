const { ethers } = require("hardhat");
const { expect } = require("chai");

const uniswapV2Factory = require("@uniswap/v2-core/build/UniswapV2Factory.json");

describe("CTF Validator", function () {

  let factory;
  let validator;
  let goblin;
  let attacker;
  let user;

  before(async () => {

    user = await ethers.getSigner();
    const setter = await ethers.getSigner(1);

    const Factory = await ethers.getContractFactory(uniswapV2Factory.abi, uniswapV2Factory.bytecode);
    factory = await Factory.deploy(setter.address);
    await factory.deployed();

    let Validator = await ethers.getContractFactory("Validator");
    validator = await Validator.deploy(factory.address);
    await validator.deployed();

    let Attacker = await ethers.getContractFactory("Attacker");
    attacker = await Attacker.deploy();
    await attacker.deployed();

    // Set up validator

    await validator.connect(user).deploy(1);

    const goblinAddress = await validator.deployments(user.address, 1);
    goblin = await ethers.getContractAt("GoudaGoblin", goblinAddress);
    await goblin.deployed();

  });


  it("Should should deploy pair and goblin as expected", async function () {

    // Validator should validate false initially
    expect(await validator.test(user.address, 1)).to.be.false;

    // Gouda price should be reported as 100 gold
    expect(await goblin.fetchGoudaPrice()).to.equal(ethers.utils.parseUnits('100', 'gwei'));

  });

  it("Should validate part 1 correctly", async function () {

    // (1) Get addresses
    const goldAddress = await goblin.gold();
    const goudaAddress = await goblin.gouda();
    const lpAddress = await goblin.liquidityPool();

    // (2) Execute attack

    await attacker.execute(
      goblin.address,
      lpAddress,
      goudaAddress,
      goldAddress
    );

    // (3) Validate results

    expect(await goblin.lockedGouda()).to.equal(0);
    expect(await validator.test(user.address, 1)).to.be.true;

  });

});