const { ethers } = require('hardhat');
const { expect } = require('chai');
const { setBalance } = require("@nomicfoundation/hardhat-network-helpers");

function testCursedGrimoires(subsuiteName, input) {

  describe(subsuiteName, async function() {
    
    let grimoires;
    let recipient;

    before(async function() {
      recipient = new ethers.Wallet(input.recipient.privateKey, ethers.provider);
      setBalance(recipient.address, ethers.utils.parseEther("1"));
    });

    beforeEach(async function() {
      const Grimoires = await ethers.getContractFactory("CursedGrimoires");
      grimoires = await Grimoires.deploy();

      await grimoires.deployed();
    });

    it("Should register valid public keys", async function() {
      const goodTx = grimoires
        .connect(recipient)
        .register(input.recipient.publicKeyX, input.recipient.publicKeyY);

      await expect(goodTx).to.not.be.reverted;
    });

    it("Should not register invalid public keys", async function() {
      let badTx = grimoires
        .connect(recipient)
        .register(input.recipient.publicKeyY, input.recipient.publicKeyX);
      
      await expect(badTx).to.be.reverted;
    });

    it("Should compute stealth address", async function() {
      await grimoires.connect(recipient)
        .register(input.recipient.publicKeyX, input.recipient.publicKeyY);

      const result = await grimoires.getStealthAddress(recipient.address, input.transfer.secret);

      expect(result.stealthAddress)
        .to.equal(input.transfer.stealthAddress);
      expect(result.publishedDataX)
        .to.equal(input.transfer.publishedX);
      expect(result.publishedDataY)
        .to.equal(input.transfer.publishedY);
    });

    it("Should revert if getting stealth addresses of unregistered recipients", async function() {
      await expect(grimoires.getStealthAddress(recipient.address, input.transfer.secret))
        .to.be.reverted;
    });

    it("Should print()", async function() {
      const sender = await ethers.getSigner();
      grimoires.print(sender.address, input.transfer.tokenId);

      expect(await grimoires.ownerOf(input.transfer.tokenId))
        .to.equal(sender.address);
    });

    it("Should stealthTransfer()", async function() {
      const sender = await ethers.getSigner();
      const transfer = input.transfer;
      grimoires.print(sender.address, input.transfer.tokenId);

      const transferTx = grimoires.stealthTransfer(
        transfer.stealthAddress, 
        transfer.tokenId,
        transfer.publishedX,
        transfer.publishedY
      );

      await expect(transferTx)
        .to.emit(grimoires, "StealthTransfer")
        .withArgs(transfer.stealthAddress, transfer.publishedX, transfer.publishedY);

      expect(await grimoires.ownerOf(transfer.tokenId))
        .to.equal(transfer.stealthAddress);
    });
  });
}

module.exports.testCursedGrimoires = testCursedGrimoires;

////
// getStealthAddress() implemented in Javascript
////

/*
const EC = require('elliptic').ec;
const ec = new EC('secp256k1');

function getStealthAddress(privateKey, secret) {

  // Remove "0x" prefix for elliptic library
  const privateKeyString = privateKey.slice(2);
  const publicKey = ec.g.mul(privateKeyString);

  // Remove "0x" prefix for elliptic library
  const secretString = secret.slice(2);
  const publishedData = ec.g.mul(secretString);

  const Q = publicKey.mul(secretString);
  const Qx = '0x' + Q.x.toString('hex');
  const Qy = '0x' + Q.y.toString('hex');

  const hQ = ethers.utils.solidityKeccak256(
    ['uint256', 'uint256'],
    [ Qx, Qy ]
  );
  // Remove "0x" prefix for elliptic library
  const hQString = hQ.slice(2);

  const stealthPublicKey = ec.g.mul(hQString).add(publicKey);
  const stealthAddress = ethers.utils.computeAddress(
    "0x04"
    + stealthPublicKey.x.toString('hex')
    + stealthPublicKey.y.toString('hex')
  );

  return { 
    stealthAddress: stealthAddress,
    publishedDataX: '0x' + publishedData.x.toString('hex'),
    publishedDataY: "0x" + publishedData.y.toString('hex')
  };
}
*/