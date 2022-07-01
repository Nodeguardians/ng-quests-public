const { ethers } = require("hardhat");

describe("SimpleGameV2", function () {
    
    let testProbeContract;

    before(async function () {
        const testProbeFactory = await ethers.getContractFactory("TestProbe");
        testProbeContract = await testProbeFactory.deploy();

        await testProbeContract.deployed();
    });

    it("test2", async () => {
        await testProbeContract.test2({ value: ethers.utils.parseEther("1") });
    });

});
