const { ethers, web3 } = require("hardhat");
const { expect } = require("chai");

const { deploy } = require("../scripts/deploy.js");

describe("UltimateSuitV1", function () {

    const THRESHOLD = ethers.utils.parseUnits("100", "gwei");
    // Keccak-256 hash of OpenZeppelin's basic proxy contract bytecode
    const BYTECODE_HASH = "0xfc1ea81db44e2de921b958dc92da921a18968ff3f3465bd475fb86dd1af03986";

    let probe;
    let suitAddress;

    before(async function () {
        let ProbeFactory = await ethers.getContractFactory("TestProbe");
        probe = await ProbeFactory.deploy();

        await probe.deployed();
    });

    // Runs user-defined deploy(), and checks if proxy's bytecode matches with OpenZeppelin's
    it("Should deploy", async function () {

        suitAddress = await deploy(THRESHOLD);

        let byteCode = await web3.eth.getCode(suitAddress);
        let byteCodeHash = ethers.utils.keccak256(byteCode);
        expect(byteCodeHash).to.be.equal(BYTECODE_HASH);

    });

    it("Should work", async function () {
        expect(await probe.test1(suitAddress, {
            value: ethers.utils.parseUnits("150", "gwei")
        }));
    });

});