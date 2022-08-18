const { ethers } = require("hardhat");
const { expect } = require("chai");

function testTree(input) {
  describe(input.name, function () {
    let TreeFactory;
    let tree;

    before(async function () {
      TreeFactory = await ethers.getContractFactory("SacredTree");
      tree = await TreeFactory.deploy();

      await tree.deployed();
    });

    it("Should verify proof correctly", async function () {

        let result = await tree.verify(
          input.goodProof.address,
          input.goodProof.proof
        );

        expect(result).to.be.true;

    });

    it("Should not verify bad proof", async function () {

      let result = await tree.verify(
        input.badProof.address,
        input.badProof.proof
      );

      expect(result).to.be.false;

    });
  });

}

module.exports.testTree = testTree;