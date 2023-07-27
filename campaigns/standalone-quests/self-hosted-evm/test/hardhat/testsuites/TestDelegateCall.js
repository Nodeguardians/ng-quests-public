const { expect } = require("chai");
const { ethers } = require("hardhat");

function testDelegateCall(subsuiteName) {
  describe(subsuiteName, function () {
    let evm;
    let calleeAddress;
    let delegateCallerAddress;

    let CalleeFactory;
    let DelegateCallerFactory;

    before(async function () {
      const evmFactory = await ethers.getContractFactory("sEVM");

      evm = await evmFactory.deploy();
      await evm.deployed();
      await evm.createAccount("0xc0ffee254729296a45a3885639AC7E10F9d54979", 0);

      CalleeFactory = await ethers.getContractFactory("Callee");
      DelegateCallerFactory = await ethers.getContractFactory("DelegateCaller");
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

    it("Should correctly deploy the DelegateCaller contract", async function () {
      delegateCallerAddress = await evm.getNextDeploymentAddress(
        "0xc0ffee254729296a45a3885639AC7E10F9d54979"
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: ethers.constants.AddressZero,
        value: 0,
        data: DelegateCallerFactory.getDeployTransaction(calleeAddress).data,
      });

      const account = await evm.accounts(delegateCallerAddress);
      const delegateCallerArtifact = require("../../../artifacts/contracts/test/helpers/DelegateCaller.sol/DelegateCaller.json");
      expect(account.bytecode).to.equal(
        delegateCallerArtifact.deployedBytecode
      );
    });

    it("Should be able to delegatecall a view function without value", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("callView")]
      );

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: delegateCallerAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [0])
      );
    });

    it("Should not be able to delegatecall a view function with value", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("callView")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: delegateCallerAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should be able to delegatecall a pure function without value", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("callPure")]
      );

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: delegateCallerAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should not be able to delegatecall a pure function with value", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("callPure")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: delegateCallerAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should not be able to delegatecall a non payable function with value", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: delegateCallerAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should be able to delegatecall and forward the revert reason", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("callRevert", [0])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: delegateCallerAddress,
          value: 0,
          data: calldata,
        })
      ).to.be.revertedWith("This function should revert");

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

    it("Should forward the revert when an invalid signature is provided", async function () {
      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: delegateCallerAddress,
          value: 0,
          data: "0x00000000",
        })
      ).to.be.reverted;
    });

    it("Should be able to delegatecall a state changing function", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: delegateCallerAddress,
        value: 0,
        data: calldata,
      });
    });

    it("Should have modified the DelegateCaller contract's storage", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: delegateCallerAddress,
        value: 0,
        data: DelegateCallerFactory.interface.encodeFunctionData("value"),
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [5])
      );
    });

    it("Should not have modified the Callee contract's storage", async function () {
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

    it("Should not be able to delegatecall with more value than balance", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: delegateCallerAddress,
          value: 2,
          data: calldata,
        })
      ).to.be.revertedWith("sEVM: insufficient balance");
    });

    it("Should not allow delegatecalls not originating from the sEVM", async function () {
      await expect(
        evm.delegateCall(
          {
            origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegator: ethers.constants.AddressZero,
            to: delegateCallerAddress,
            value: 1,
            data: "0x",
          },
          true
        )
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
        _evm.delegateCall(
          {
            origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegator: ethers.constants.AddressZero,
            to: calleeAddress,
            value: 0,
            data: CalleeFactory.interface.encodeFunctionData("call", [5]),
          },
          true,
          {
            from: impersonatedSigner.address,
          }
        )
      ).to.be.revertedWith("sEVM: read only");
    });

    it("Should have a correct context", async function () {
      const calldata = DelegateCallerFactory.interface.encodeFunctionData(
        "delegateCall",
        [CalleeFactory.interface.encodeFunctionData("getContext")]
      );

      let result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: delegateCallerAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(
          ["address", "address", "address", "address"],
          [
            "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegateCallerAddress,
            calleeAddress,
          ]
        )
      );
    });
  });
}

module.exports = {
  testDelegateCall,
};
