const { ethers } = require("hardhat");
const { expect } = require("chai");

// The root is hashed so you cannot just copy the answer...
const ROOT_HASH = "0xbd150162dead740efc1f898cae744c69ccf898415b98d8c95e9ae7116361796c";

describe("SacredTree (Part 1)", function () {
  let TreeFactory;
  let tree;

  before(async function () {
    TreeFactory = await ethers.getContractFactory("SacredTree");
    tree = await TreeFactory.deploy();

    await tree.deployed();
  });

  it("Should have the correct root", async function () {
    let root = await tree.root();
    let hash = ethers.utils.keccak256(root);
    expect(hash).to.be.equals(ROOT_HASH);
  });

});
