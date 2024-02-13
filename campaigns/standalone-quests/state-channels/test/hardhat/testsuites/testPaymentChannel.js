const { ethers } = require("hardhat");
const { expect } = require("chai");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

function testPaymentChannel(subsuiteName, input) {

  describe(subsuiteName, function () {

    let PaymentChannelFactory;
    let sender;
    let receiver;

    let paymentChannel;
    let signature;

    before(async function () {
      PaymentChannelFactory =
        await ethers.getContractFactory("PaymentChannel");

      [sender, receiver] = await ethers.getSigners();
    });

    beforeEach(async function () {
      paymentChannel = await PaymentChannelFactory.deploy(
        receiver.address,
        input.time,
        { value: input.totalFunds }
      );

      let message = ethers.utils.solidityPack(
        ["address", "uint256"],
        [paymentChannel.address, input.paymentAmount]
      );
      signature =
        await sender.signMessage(ethers.utils.arrayify(message));
    });

    it("Should send money", async function () {
      let tx = paymentChannel.connect(receiver).closeChannel(
        input.paymentAmount,
        signature
      );

      await expect(tx).to.changeEtherBalances(
        [sender, receiver],
        [input.totalFunds - input.paymentAmount, input.paymentAmount]
      )
      expect(await paymentChannel.isActive()).to.be.false;
    });

    it("Should reject bad signature", async function () {
      await expect(paymentChannel.connect(receiver).closeChannel(
        input.paymentAmount - 1,
        signature
      )).to.be.reverted;
    });

    it("Should not accept more than one message", async function () {
      await paymentChannel.connect(receiver).closeChannel(
        input.paymentAmount,
        signature
      );

      await expect(paymentChannel.connect(receiver).closeChannel(
        input.paymentAmount,
        signature
      )).to.be.reverted;
    });

    it("Should only allow receiver to close channel", async function () {
      await expect(paymentChannel.connect(sender).closeChannel(
        input.paymentAmount,
        signature
      )).to.be.reverted;
    });

    it("Should time out", async function () {
      // Should not time out before expiration
      await expect(
        paymentChannel.connect(sender).timeOut()
      ).to.be.reverted;

      await time.increase(input.time + 1);

      // After expiration, receiver cannot close channel 
      await expect(paymentChannel.connect(receiver).closeChannel(
        input.paymentAmount,
        signature
      )).to.be.reverted;

      // timeout() should return all funds to sender
      let tx = paymentChannel.connect(sender).timeOut();
      await expect(tx).to.changeEtherBalance(
        sender, input.totalFunds
      );

      expect(await paymentChannel.isActive()).to.be.false;
    });

    it("Should allow time to be extended", async function () {
      await paymentChannel.connect(sender).addTime(input.time);
      await time.increase(input.time + 1);

      await expect(paymentChannel.timeOut()).to.be.reverted;
      await time.increase(input.time + 1);

      await paymentChannel.timeOut();
      expect(await paymentChannel.isActive()).to.be.false;
    });
  });
}

module.exports.testPaymentChannel = testPaymentChannel;