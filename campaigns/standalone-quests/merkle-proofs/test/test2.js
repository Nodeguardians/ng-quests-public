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

    it("Should verify proofs correctly", async function () {
        
        for (let i = 0; i < testdata.proofs.length; i++) {

            let result = await tree.verify(
                testdata.proofs[i].address,
                testdata.proofs[i].proof
            );

            expect(result).to.be.true;

        }

    });

    it("Should not verify bad proofs", async function () {
        
        for (let i = 0; i < testdata.badProofs.length; i++) {
            
            let result = await tree.verify(
                testdata.badProofs[i].address,
                testdata.badProofs[i].proof
            );

            expect(result).to.be.false;

        }

    });


});