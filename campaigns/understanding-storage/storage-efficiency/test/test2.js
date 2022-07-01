const { ethers } = require("hardhat");

function sum(lines, x) {
    let sum = 0;
    for (let i = 1; i < lines.length; i++) {
        sum += lines[i] * (i * x)
    }
    return sum;
}

describe("Elegy2", function () {

    let TestProbe;
    let probe;

    let TEST_ARRAY = [25021323, 62912, 98122, 1231, 4088, 7873, 239, 191, 3941, 12, 91240, 1234901, 12390121, 1234101, 1412, 39013241];

    before(async function () {
        TestProbe = await ethers.getContractFactory("TestProbe2");
        probe = await TestProbe.deploy(TEST_ARRAY);

        await probe.deployed();
    });

    it("Should work", async function () {
        await probe.test1(
            [3, 5], 
            [55000, 21000], 
            [sum(TEST_ARRAY, 3), sum(TEST_ARRAY, 5)]
        );
    });

    // Ensures user cannot cheat the first test by making totalSum a function
    it("Should have totalSum as a public variable", async function () {
        await probe.test2();
    });

});