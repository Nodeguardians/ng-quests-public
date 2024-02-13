const { ethers } = require("hardhat");
const { expect } = require("chai");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

function testMineCart(subsuiteName, input) {

  describe(subsuiteName, function () {

    const POOL_FUNDS = ethers.utils.parseEther("10");

    let MineCartFactory;

    let worker1;
    let worker2;

    let mineCart;

    before(async function () {
      MineCartFactory = await ethers.getContractFactory(
        "MineCart"
      );

      [worker1, worker2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      mineCart = await MineCartFactory.deploy(
        worker1.address,
        worker2.address,
        input.timePerMove,
        { value: POOL_FUNDS }
      );
    });

    function updateWithSignature(messageNum) {
      const message = ethers.utils.solidityPack(
        ["address", "uint256", "uint256"],
        [mineCart.address, input.ores[messageNum], messageNum]
      );

      const [sender, signer] = (messageNum % 2 == 0) 
        ? [worker2, worker1]
        : [worker1, worker2];

      const signature = signer.signMessage(
        ethers.utils.arrayify(message)
      );

      return mineCart.connect(sender).update(
        input.ores[messageNum],
        messageNum,
        signature
      );
    }

    it("Should update state with signature", async function () {
      await updateWithSignature(2);

      expect(await mineCart.totalOres()).to.equal(input.ores[2]);
      expect(await mineCart.messageNum()).to.equal(3);

      await updateWithSignature(5);

      expect(await mineCart.totalOres()).to.equal(input.ores[5]);
      expect(await mineCart.messageNum()).to.equal(6);
    });

    it("Should reward winner when update and totalOres > 20", async function () {
      await updateWithSignature(3)

      const winningTurn = input.ores.length - 1;
      const winner = winningTurn % 2 == 1 ? worker1 : worker2;

      const winningTx = updateWithSignature(winningTurn);

      await expect(winningTx).to.changeEtherBalance(winner, POOL_FUNDS);
      expect(await mineCart.isActive()).to.be.false;
    });
    
    it("Should load", async function () {

      let totalOres = 0;
      for (let i = 0; i < input.loads.length; i++) {
        const activeWorker = (i % 2 == 0) ? worker1 : worker2;

        totalOres += input.loads[i];
        if (totalOres % 5 == 0) {
          totalOres -= 2;
        }

        await mineCart.connect(activeWorker).load(input.loads[i]);

        expect(await mineCart.totalOres()).to.equal(totalOres);

        if (totalOres < 21) {
          expect(await mineCart.messageNum()).to.equal(i + 2);
        }

      }
    });

    it("Should not load more than 4 ores at once", async function () {

      await expect(
        mineCart.connect(worker1).load(5)
      ).to.be.reverted;

    });

    it("Should reward winner when load and totalOres > 20", async function () {

      let tx;
      for (let i = 0; i < input.loads.length; i++) {
        const activeWorker = (i % 2 == 0) ? worker1 : worker2;
        tx = mineCart.connect(activeWorker).load(input.loads[i]);

        await tx;
      }

      const winningTurn = input.loads.length - 1;
      const winner = winningTurn % 2 == 1 ? worker2 : worker1;

      await expect(tx).to.changeEtherBalance(winner, POOL_FUNDS);
      expect(await mineCart.isActive()).to.be.false;
    });

    it("Should time out", async function () {
      // Time out 1 turn before winning turn
      const lastTurn = input.ores.length - 1;
      await updateWithSignature(lastTurn - 1);

      await expect(mineCart.timeOut()).to.be.reverted;

      await time.increase(input.timePerMove + 1);

      // Time out and check non-active worker is rewarded
      const winner = lastTurn % 2 == 1 ? worker2 : worker1;

      const timeOutTx = mineCart.timeOut();

      await expect(timeOutTx).to.changeEtherBalance(winner, POOL_FUNDS);
      expect(await mineCart.isActive()).to.be.false;
    });

    it("Should reject bad signature", async function () {

      const message = ethers.utils.solidityPack(
        ["address", "uint256", "uint256"],
        [mineCart.address, input.ores[3], 3]
      );

      const signature = worker1.signMessage(
        ethers.utils.arrayify(message)
      );

      const badTx = mineCart.connect(worker1).update(
        input.ores[3],
        3,
        signature
      );

      await expect(badTx).to.be.reverted;

    });

    it("Should reject old messageNum", async function () {
      await updateWithSignature(5);
      const badTx = updateWithSignature(3);

      await expect(badTx).to.be.reverted;
    });

  })
}

module.exports.testMineCart = testMineCart;