const { ethers } = require("hardhat");
const { arrayify, keccak256, parseEther } = require("ethers/lib/utils");
const { expect } = require("chai");

const { approveBlessing, approveInvitation } = require("../scripts/sign.js");

describe("Grandmasters", function () {

    let grandmasters;
    let creator;
    let addr1;
    let addr2;

    before(async function () {
        [creator, addr1, addr2] = await ethers.getSigners();
    });
  
    beforeEach(async function () {

        GrandmastersFactory = await ethers.getContractFactory("Grandmasters");

        grandmasters = await GrandmastersFactory.deploy(
            {value: ethers.utils.parseEther("100")}
        );
  
        await grandmasters.deployed();

    });
  
    it("Should initially only have contract creator as grandmaster", async function () {

        let result = await grandmasters.grandmasters(creator.address);

        expect(result).to.be.true;

        result = await grandmasters.grandmasters(addr1.address);

        expect(result).to.be.false;

    });

    it("Should have receiveBlessing() working", async function () {

        // 1. Test first blessing
        let signature = approveBlessing(
            addr1.address, parseEther("1"), 0, creator
        );

        let blessingTx = await grandmasters
            .connect(addr1)
            .receiveBlessing(parseEther("1"), signature);

        let balance = await ethers.provider.getBalance(addr1.address);

        expect(balance).to.be
            .closeTo(parseEther("10001"), parseEther("0.1"));

        // 2. Test replay (should fail)
        let replay = grandmasters
            .connect(addr1)
            .receiveBlessing(parseEther("1"), signature);
        expect(replay).to.be.reverted;

        // 3. Test second blessing (nonce incremented)
        signature = approveBlessing(
            addr1.address, parseEther("1"), 1, creator
        );

        blessingTx = await grandmasters
            .connect(addr1)
            .receiveBlessing(parseEther("1"), signature);
        result = await blessingTx.wait();

        balance = await ethers.provider.getBalance(addr1.address);

        expect(balance).to.be
            .closeTo(parseEther("10002"), parseEther("0.1"));

    });

    it("Should have acceptInvite() working", async function () {

        let signature = approveInvitation(addr1.address, creator);

        await grandmasters
            .connect(addr1)
            .acceptInvite(signature);

        expect(await grandmasters.grandmasters(addr1.address))
            .to.be.true;
        
        // Test if addr1 signature will be accepted
        signature = approveInvitation(addr2.address, addr1);

        await grandmasters
            .connect(addr2)
            .acceptInvite(signature);

        expect(await grandmasters.grandmasters(addr2.address)).to.be.true;
        
    });

    it("Should not accept invalid signatures", async function () {

        // 1. Test invalid invite signature
        let signature = approveInvitation(addr1.address, addr2);

        let inviteTx = grandmasters
            .connect(addr1)
            .acceptInvite(signature);

        await expect(inviteTx).to.be.reverted;

        // Test invalid blessing signature
        signature = approveBlessing(
            addr1.address, parseEther("1"), 0, addr2
        );

        let blessingTx = grandmasters
            .connect(addr1)
            .receiveBlessing(parseEther("1.1"), signature);
        expect(blessingTx).to.be.reverted;

    });

});
