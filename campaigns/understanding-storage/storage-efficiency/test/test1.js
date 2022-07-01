const { ethers } = require("hardhat");

describe("Elegy1", function () {

    let Probe;
    let probe;

    before(async function () {
       Probe = await ethers.getContractFactory("TestProbe1");
       probe = await Probe.deploy();
    });

    it("Should be cheap to write onto", async function () {
        await probe.test1();
    });

    it("Should should still store data", async function () {
        await probe.test2();
    });

});
