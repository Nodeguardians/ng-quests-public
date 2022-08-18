const { ethers } = require("hardhat");
const { expect } = require("chai");

const { deploy } = require("../scripts/deploy.js");

describe("deploy() (Part 1)", function () {
  const THRESHOLD = ethers.utils.parseEther("1");
  // Keccak-256 hash of OpenZeppelin's basic proxy contract bytecode
  const BYTECODE_HASH =
    "0xfc1ea81db44e2de921b958dc92da921a18968ff3f3465bd475fb86dd1af03986";

  // Runs user-defined deploy(), and checks if proxy's bytecode matches with OpenZeppelin's
  it("Should deploy proxy with OpenZeppelin", async function () {
    suitContract = await deploy(THRESHOLD);

    let byteCode = await ethers.provider.getCode(suitContract.address);
    let byteCodeHash = ethers.utils.keccak256(byteCode);
    expect(byteCodeHash).to.be.equal(BYTECODE_HASH);
  });

});
