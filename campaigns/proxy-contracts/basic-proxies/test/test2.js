const { expect } = require("chai");
const { ethers, web3 } = require("hardhat");

describe("UpgradeableMechSuit", function () {

    let ProbeFactory;
    let probe;

    let STORAGE_SLOT = '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc';
    let ADMIN_SLOT = '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103';

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

    it("Should be EIP-1967 compliant", async function () {
        
        let suitAddress = await probe.suit();
        let implAddress = await probe.impl();

        let implSlot = await web3.eth.getStorageAt(
            suitAddress,
            STORAGE_SLOT
        );

        expect('0x' + implSlot.slice(26))
            .to.be.equals(implAddress.toLowerCase());

        let adminSlot = await web3.eth.getStorageAt(
            suitAddress,
            ADMIN_SLOT
        );

        expect('0x' + adminSlot.slice(26))
            .to.be.equals(probe.address.toLowerCase());

    });

    it("Should only allow admin to upgrade", async function () {
        await expect(probe.test3()).to.be.reverted;
    });

});