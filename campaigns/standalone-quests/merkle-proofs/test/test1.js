const { expect } = require("chai");
const { ethers } = require("hardhat");
const testdata = require("./testdata.js");

describe("SacredTree", function () {

    let TreeFactory;
    let tree;

    before(async function () {
        TreeFactory = await ethers.getContractFactory("SacredTree");
        tree = await TreeFactory.deploy();

        await tree.deployed();
    });

    it("Should have the correct root", async function () {

        expect(await tree.root())
            .to.be.equals(testdata.root);

    });

});