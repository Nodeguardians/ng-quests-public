const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCallCode(subsuiteName) {
  describe(subsuiteName, function () {
    let evm;
    let calleeAddress;
    let callCoderAddress;

    let CalleeFactory;
    let CallCoderFactory;

    before(async function () {
      const evmFactory = await ethers.getContractFactory("sEVM");

      evm = await evmFactory.deploy();
      await evm.deployed();
      await evm.createAccount("0xc0ffee254729296a45a3885639AC7E10F9d54979", 0);

      CalleeFactory = await ethers.getContractFactory("Callee");
      CallCoderFactory = await ethers.getContractFactory("CallCoder");
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

    it("Should correctly deploy the CallCoder contract", async function () {
      callCoderAddress = await evm.getNextDeploymentAddress(
        "0xc0ffee254729296a45a3885639AC7E10F9d54979"
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: ethers.constants.AddressZero,
        value: 0,
        data: CallCoderFactory.getDeployTransaction(calleeAddress).data,
      });

      const account = await evm.accounts(callCoderAddress);
      const callCoderArtifact = require("../../../artifacts/contracts/Test/utils/CallCoder.sol/CallCoder.json");
      expect(account.bytecode).to.equal(callCoderArtifact.deployedBytecode);
    });

    it("Should be able to callcode a view function without value", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("callView")]
      );

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: callCoderAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [0])
      );
    });

    it("Should not be able to callcode a view function with value", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("callView")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: callCoderAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should be able to callcode a pure function without value", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("callPure")]
      );

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: callCoderAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should not be able to callcode a pure function with value", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("callPure")]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: callCoderAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should not be able to callcode a non payable function with value", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: callCoderAddress,
          value: 1,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should be able to callcode and forward the revert reason", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("callRevert", [0])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: callCoderAddress,
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
          to: callCoderAddress,
          value: 0,
          data: "0x00000000",
        })
      ).to.be.reverted;
    });

    it("Should be able to callcode a state changing function", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: callCoderAddress,
        value: 0,
        data: calldata,
      });
    });

    it("Should have modified the CallCoder contract's storage", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: callCoderAddress,
        value: 0,
        data: CallCoderFactory.interface.encodeFunctionData("value"),
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

    it("Should not be able to callcode with more value than balance", async function () {
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("call", [5])]
      );

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: callCoderAddress,
          value: 2,
          data: calldata,
        })
      ).to.be.revertedWith("sEVM: insufficient balance");
    });

    it("Should not allowcallcodes not originating from the sEVM", async function () {
      await expect(
        evm.delegateCall(
          {
            origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegator: ethers.constants.AddressZero,
            to: callCoderAddress,
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
      const calldata = CallCoderFactory.interface.encodeFunctionData(
        "callCode",
        [CalleeFactory.interface.encodeFunctionData("getContext")]
      );

      let result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: callCoderAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(
          ["address", "address", "address", "address"],
          [
            "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            callCoderAddress,
            callCoderAddress,
            calleeAddress,
          ]
        )
      );
    });
  });
}

module.exports = {
  testCallCode,
};
