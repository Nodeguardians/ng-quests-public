const { expect } = require("chai");
const { ethers } = require("hardhat");

function testStaticCall(subsuiteName) {
  describe(subsuiteName, function () {
    let evm;

    let calleeAddress;
    let staticCallerAddress;

    let StaticCallerFactory;
    let CalleeFactory;

    before(async function () {
      const evmFactory = await ethers.getContractFactory("sEVM");

      evm = await evmFactory.deploy();
      await evm.deployed();
      await evm.createAccount("0xc0ffee254729296a45a3885639AC7E10F9d54979", 1);

      StaticCallerFactory = await ethers.getContractFactory("StaticCaller");
      CalleeFactory = await ethers.getContractFactory("Callee");
    });

    it("Should correctly deploy the Callee contract", async function () {
      calleeAddress = await evm.getNextDeploymentAddress(
        "0xc0ffee254729296a45a3885639AC7E10F9d54979"
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: ethers.constants.AddressZero,
        value: 0,
        data: CalleeFactory.getDeployTransaction(1).data,
      });

      expect(
        await evm.readAccountStorageAt(
          calleeAddress,
          "0x0000000000000000000000000000000000000000000000000000000000000000"
        )
      ).to.equal(
        "0x0000000000000000000000000000000000000000000000000000000000000001"
      );
    });

    it("Should be able to call the Callee contract", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: calleeAddress,
        value: 0,
        data: CalleeFactory.interface.encodeFunctionData("value"),
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should correctly deploy the StaticCaller contract", async function () {
      staticCallerAddress = await evm.getNextDeploymentAddress(
        "0xc0ffee254729296a45a3885639AC7E10F9d54979"
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: ethers.constants.AddressZero,
        value: 0,
        data: StaticCallerFactory.getDeployTransaction(calleeAddress).data,
      });

      const account = await evm.accounts(staticCallerAddress);
      const callerArtifact = require("../../../artifacts/contracts/test/helpers/StaticCaller.sol/StaticCaller.json");
      expect(account.bytecode).to.equal(callerArtifact.deployedBytecode);
    });

    it("Should be able to staticcall a view function without value", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("callView")]
      );

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: staticCallerAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should not be able to staticcall a view function with value", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("callView")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should be able to staticcall a pure function without value", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("callPure")]
      );

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: staticCallerAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should not be able to staticcall a pure function with value", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("callPure")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should not be able to staticcall a non payable function with value", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should be able to staticcall and forward the revert reason", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("callPureRevert")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 0,
          data: calldata,
        })
      ).to.be.revertedWith("This function should revert");
    });

    it("Should forward the revert when an invalid signature is provided", async function () {
      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 0,
          data: "0x00000000",
        })
      ).to.be.reverted;
    });

    it("Should not be able to staticcall a state changing function", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 0,
          data: calldata,
        })
      ).to.be.revertedWith("sEVM: read only");
    });

    it("Should not be able to staticcall with more value than balance", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: staticCallerAddress,
          value: 2,
          data: calldata,
        })
      ).to.be.revertedWith("sEVM: insufficient balance");
    });

    it("Should not allow staticCall not originating from the sEVM", async function () {
      await expect(
        evm.staticCall({
          origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          delegator: ethers.constants.AddressZero,
          to: staticCallerAddress,
          value: 1,
          data: "0x",
        })
      ).to.be.revertedWith("sEVM: msg.sender must be sEVM");
    });

    it("Should not allow a state changing operation while in a readonly context", async function () {
      const impersonatedSigner = await ethers.getImpersonatedSigner(
        evm.address
      );
      const evmFactory = await ethers.getContractFactory(
        "sEVM",
        impersonatedSigner
      );

      const _evm = evmFactory.attach(evm.address);

      await network.provider.send("hardhat_setBalance", [
        evm.address,
        "0x1000000000000000000",
      ]);

      await expect(
        _evm.staticCall(
          {
            origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegator: ethers.constants.AddressZero,
            to: calleeAddress,
            value: 0,
            data: CalleeFactory.interface.encodeFunctionData("call", [5]),
          },
          {
            from: impersonatedSigner.address,
          }
        )
      ).to.be.revertedWith("sEVM: read only");
    });

    it("Should have a correct context", async function () {
      const calldata = StaticCallerFactory.interface.encodeFunctionData(
        "staticCall",
        [CalleeFactory.interface.encodeFunctionData("getContext")]
      );

      let result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: staticCallerAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(
          ["address", "address", "address", "address"],
          [
            "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            staticCallerAddress,
            calleeAddress,
            calleeAddress,
          ]
        )
      );
    });
  });
}

module.exports = {
  testStaticCall,
};
