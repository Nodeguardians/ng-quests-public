const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("UpgradeableMechSuit", function () {

    let ProbeFactory;
    let probe;

    before(async function () {
        ProbeFactory = await ethers.getContractFactory("TestProbe");
        probe = await ProbeFactory.deploy();

        await probe.deployed();
    });

    it("Should forward calls to delegate", async function () {
        expect(await probe.test1({value: 1000000000}));
    });

    it("Should be upgradeable", async function () {
        expect(await probe.test2({value: 1000000000}));
    });

});