const { ethers } = require('hardhat');
const { expect } = require('chai');
const { setBalance } = require("@nomicfoundation/hardhat-network-helpers");

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

  // console.log(hQString);
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

function testCursedGrimoires(input) {

  describe(input.name, async function() {
    let grimoires;
    let recipient;
    let publicKey;

    let expected

    before(async function() {
      recipient = new ethers.Wallet(input.privateKey, ethers.provider);
      setBalance(recipient.address, ethers.utils.parseEther("1"));

      expected = getStealthAddress(input.privateKey, input.secret);

      publicKey = {
        x: ethers.utils.hexDataSlice(recipient.publicKey, 1, 33),
        y: ethers.utils.hexDataSlice(recipient.publicKey, 33)
      }
    });

    beforeEach(async function() {
      const Grimoires = await ethers.getContractFactory("CursedGrimoires");
      grimoires = await Grimoires.deploy();

      await grimoires.deployed();
    });

    it("Should register valid public keys", async function() {
      let goodTx = grimoires
        .connect(recipient)
        .register(publicKey.x, publicKey.y);

      await expect(goodTx).to.not.be.reverted;
    });

    it("Should not register invalid public keys", async function() {
      let badTx = grimoires
        .connect(recipient)
        .register(publicKey.y, publicKey.x);
      
      await expect(badTx).to.be.reverted;
    });

    it("Should compute stealth address", async function() {
      await grimoires.connect(recipient).register(publicKey.x, publicKey.y);

      const result = await grimoires.getStealthAddress(recipient.address, input.secret);
      const expected = getStealthAddress(input.privateKey, input.secret);

      expect(result.stealthAddress)
        .to.equal(expected.stealthAddress);
      expect(result.publishedDataX)
        .to.equal(expected.publishedDataX);
      expect(result.publishedDataY)
        .to.equal(expected.publishedDataY);
    });

    it("Should revert if getting stealth addresses of unregistered recipients", async function() {
      await expect(grimoires.getStealthAddress(recipient.address, input.secret))
        .to.be.reverted;
    });

    it("Should print()", async function() {
      let sender = await ethers.getSigner();
      grimoires.print(sender.address, input.tokenId);

      expect(await grimoires.ownerOf(input.tokenId))
        .to.equal(sender.address);
    });

    it("Should stealthTransfer()", async function() {
      let sender = await ethers.getSigner();
      grimoires.print(sender.address, input.tokenId);

      const transferTx = grimoires.stealthTransfer(
        expected.stealthAddress, 
        input.tokenId,
        expected.publishedDataX,
        expected.publishedDataY
      );

      await expect(transferTx)
        .to.emit(grimoires, "StealthTransfer")
        .withArgs(expected.stealthAddress, expected.publishedDataX, expected.publishedDataY);

      expect(await grimoires.ownerOf(input.tokenId))
        .to.equal(expected.stealthAddress);
    });
  });
}

module.exports.testCursedGrimoires = testCursedGrimoires;