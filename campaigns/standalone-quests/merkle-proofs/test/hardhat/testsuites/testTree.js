const { ethers } = require("hardhat");
const { expect } = require("chai");

function testTree(subsuiteName, proofTests) {
  describe(subsuiteName, function () {
    let TreeFactory;
    let tree;

    before(async function () {
      TreeFactory = await ethers.getContractFactory("SacredTree");
      tree = await TreeFactory.deploy();

      await tree.deployed();
    });

    it("Should verify proof correctly", async function () {

        let result = await tree.verify(
          proofTests.valid.address,
          proofTests.valid.proof
        );

        expect(result).to.be.true;

    });

    it("Should reject bad proof", async function () {

      let result = await tree.verify(
        proofTests.invalid.address,
        proofTests.invalid.proof
      );

      expect(result).to.be.false;

    });
  });

}

module.exports.testTree = testTree;