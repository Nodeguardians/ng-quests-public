const { expect } = require("chai");
const { ethers } = require("hardhat");

function generateRandomArray(seed, size) {
  let ret = [];

  for (let i = seed; i < seed + size; i++) {
    let bigNum = ethers.BigNumber.from(ethers.utils.keccak256(i));
    ret.push(bigNum);
  }

  return ret;
}

describe("SpiderEggs", function () {
  let TestProbe;
  let probe;

  const ids = generateRandomArray(0, 10);
  const sizes = generateRandomArray(10, 10);
  const strengths = generateRandomArray(20, 10);

  before(async function () {
    TestProbe = await ethers.getContractFactory("TestProbe");
    probe = await TestProbe.deploy(ids, sizes, strengths);

    await probe.deployed();
  });

  it("Should insert and retrieve eggs", async function () {
    await probe.test1();
  });

  it("Should fail if inserting an existing egg", async function () {
    await probe.test2();
  });

  it("Should fail if retrieving an inexistent egg", async function () {
    await probe.test3();
  });

  it("Should iterate eggs", async function () {
    let receipt = await probe.test4().then((tx) => tx.wait());

    expect(receipt.events[0].args.ids).to.have.deep.members(ids);
  });
});
