const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("HelloGuardian (Part 4)", function () {
  let HelloGuardian;
  let helloGuardian;

  before(async function () {
    HelloGuardian = await ethers.getContractFactory("HelloGuardian");
    helloGuardian = await HelloGuardian.deploy();

    await helloGuardian.deployed();
  });

  it("Should be ready to submit", async function () {
    let result = await helloGuardian.hello();
    expect(result).to.be.equals("Hello Guardian");
  });

});
