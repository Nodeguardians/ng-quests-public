const { ethers } = require("hardhat");
const { expect } = require("chai");

function testInitialGrandmaster() {
  it("Should initially only have contract creator as grandmaster", async function () {

    let [ creator, other ] = await ethers.getSigners();

    GrandmastersFactory = await ethers.getContractFactory("Grandmasters");

    const grandmasters = await GrandmastersFactory
      .connect(creator)
      .deploy({value: 100000000000000});

    await grandmasters.deployed();

    let result = await grandmasters.grandmasters(creator.address);
    expect(result).to.be.true;

    result = await grandmasters.grandmasters(other.address);
    expect(result).to.be.false;
  });
}

function testGrandmasters(testData) {

  let grandmasters;

  beforeEach(async function () {

    accounts = await ethers.getSigners();
    
    GrandmastersFactory = await ethers.getContractFactory("Grandmasters");

    const creator = await ethers.getImpersonatedSigner(testData.creator);
    grandmasters = await GrandmastersFactory
      .connect(creator)
      .deploy({value: "10000000000000000000"});

    await grandmasters.deployed();

  });

  it("Should accept valid signatures", async function () {
    await runTests(testData["valid-signatures"]);
  });

  it("Should reject invalid signatures", async function () {
    await runTests(testData["invalid-signatures"]);
  });

  it("Should resist counter replay", async function () {
    await runTests(testData["signature-replay"]);
  });

  async function runTests(tests) {
    for (const test of tests) {
      const recipient = await ethers.getImpersonatedSigner(test.recipient);
  
      let tx;
      let amount = test.amount.toString(); // For safe BigInt parsing
      if (test.action == 0) {
        tx = grandmasters
          .connect(recipient)
          .receiveBlessing(amount, test.signature);
      } else {
        tx = grandmasters
          .connect(recipient)
          .acceptInvite(test.signature);
      }
  
      if (test.shouldRevert) {
        await expect(tx).to.be.reverted;
        continue;
      }
  
      await expect(tx).to.not.be.reverted;
      if (test.action == 0) {
        await expect(tx)
          .to.changeEtherBalance(recipient, amount);
      } else {
        expect(
          await grandmasters.grandmasters(recipient.address)
        ).to.be.true;
      }
    }
  }

}

module.exports.testInitialGrandmaster = testInitialGrandmaster;
module.exports.testGrandmasters = testGrandmasters;