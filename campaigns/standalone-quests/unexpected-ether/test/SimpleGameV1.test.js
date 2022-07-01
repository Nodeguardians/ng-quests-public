const { ethers } = require("hardhat");

describe("SimpleGameV1", function () {

    let testProbeContract;

    before(async function () {
        const testProbeFactory = await ethers.getContractFactory("TestProbe");
        testProbeContract = await testProbeFactory.deploy();

        await testProbeContract.deployed();
    });

    it("test1", async () => {
        await testProbeContract.test1({ value: ethers.utils.parseEther("1") });
    });
});
