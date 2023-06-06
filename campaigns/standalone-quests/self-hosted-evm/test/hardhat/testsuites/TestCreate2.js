const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCreate2(subsuiteName) {
  describe(subsuiteName, function () {
    let evm;

    let create2Address;
    let CreatedNoParamsAddress;
    let CreatedParamsAddress;

    let Create2Factory;
    let CreatedNoParamsFactory;
    let CreatedParamsFactory;

    before(async function () {
      const evmFactory = await ethers.getContractFactory("sEVM");

      evm = await evmFactory.deploy();
      await evm.deployed();
      await evm.createAccount("0xc0ffee254729296a45a3885639AC7E10F9d54979", 10);

      Create2Factory = await ethers.getContractFactory("Create2");
      CreatedNoParamsFactory = await ethers.getContractFactory(
        "CreatedNoParams"
      );
      CreatedParamsFactory = await ethers.getContractFactory("CreatedParams");
    });

    it("Should correctly deploy the Create contract", async function () {
      create2Address = await evm.getNextDeploymentAddress(
        "0xc0ffee254729296a45a3885639AC7E10F9d54979"
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: ethers.constants.AddressZero,
        value: 0,
        data: Create2Factory.getDeployTransaction().data,
      });

      const createArtifact = require("../../../artifacts/contracts/Test/utils/Create2.sol/Create2.json");
      expect(await evm.getAccountBytecode(create2Address)).to.equal(
        createArtifact.deployedBytecode
      );
    });

    it("Should be able to create a new contract with no parameters and no value", async function () {
      CreatedNoParamsAddress = ethers.utils.getCreate2Address(
        create2Address,
        ethers.utils.hexZeroPad(ethers.utils.hexlify(1), 32),
        ethers.utils.keccak256(CreatedNoParamsFactory.bytecode)
      );

      const calldata = Create2Factory.interface.encodeFunctionData("create2", [
        CreatedNoParamsFactory.bytecode,
        1,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(
          ["address"],
          [CreatedNoParamsAddress]
        )
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 0,
        data: calldata,
      });

      const createdNoParamsArtifact = require("../../../artifacts/contracts/Test/utils/CreatedNoParams.sol/CreatedNoParams.json");
      expect(await evm.getAccountBytecode(CreatedNoParamsAddress)).to.equal(
        createdNoParamsArtifact.deployedBytecode
      );
    });

    it("Should increment the nonce of the creator contract", async function () {
      expect(await evm.getAccountNonce(create2Address)).to.equal(2);
    });

    it("Should set the nonce of the created contract to 1", async function () {
      expect(await evm.getAccountNonce(CreatedNoParamsAddress)).to.equal(1);
    });

    it("Should be able to call the newly created contract", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: CreatedNoParamsAddress,
        value: 0,
        data: CreatedNoParamsFactory.interface.encodeFunctionData("value"),
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should be able to create a new contract with no parameters and value", async function () {
      CreatedNoParamsAddress = ethers.utils.getCreate2Address(
        create2Address,
        ethers.utils.hexZeroPad(ethers.utils.hexlify(2), 32),
        ethers.utils.keccak256(CreatedNoParamsFactory.bytecode)
      );

      const calldata = Create2Factory.interface.encodeFunctionData("create2", [
        CreatedNoParamsFactory.bytecode,
        2,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 1,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(
          ["address"],
          [CreatedNoParamsAddress]
        )
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 1,
        data: calldata,
      });

      const createdNoParamsArtifact = require("../../../artifacts/contracts/Test/utils/CreatedNoParams.sol/CreatedNoParams.json");
      expect(await evm.getAccountBytecode(CreatedNoParamsAddress)).to.equal(
        createdNoParamsArtifact.deployedBytecode
      );

      expect(await evm.getAccountBalance(create2Address)).to.equal(0);
      expect(await evm.getAccountBalance(CreatedNoParamsAddress)).to.equal(1);
    });

    it("Should be able to call the newly created contract", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: CreatedNoParamsAddress,
        value: 0,
        data: CreatedNoParamsFactory.interface.encodeFunctionData("value"),
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [1])
      );
    });

    it("Should be able to create a new contract with parameters and no value", async function () {
      CreatedParamsAddress = ethers.utils.getCreate2Address(
        create2Address,
        ethers.utils.hexZeroPad(ethers.utils.hexlify(1), 32),
        ethers.utils.keccak256(
          CreatedParamsFactory.getDeployTransaction(2).data
        )
      );

      const calldata = Create2Factory.interface.encodeFunctionData("create2", [
        CreatedParamsFactory.getDeployTransaction(2).data,
        1,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["address"], [CreatedParamsAddress])
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 0,
        data: calldata,
      });

      const createdParamsArtifact = require("../../../artifacts/contracts/Test/utils/CreatedParams.sol/CreatedParams.json");
      expect(await evm.getAccountBytecode(CreatedParamsAddress)).to.equal(
        createdParamsArtifact.deployedBytecode
      );
    });

    it("Should be able to call the newly created contract", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: CreatedParamsAddress,
        value: 0,
        data: CreatedParamsFactory.interface.encodeFunctionData("value"),
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [2])
      );
    });

    it("Should be able to create a new contract with parameters and value", async function () {
      CreatedParamsAddress = ethers.utils.getCreate2Address(
        create2Address,
        ethers.utils.hexZeroPad(ethers.utils.hexlify(2), 32),
        ethers.utils.keccak256(
          CreatedParamsFactory.getDeployTransaction(2).data
        )
      );

      const calldata = Create2Factory.interface.encodeFunctionData("create2", [
        CreatedParamsFactory.getDeployTransaction(2).data,
        2,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 1,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["address"], [CreatedParamsAddress])
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: create2Address,
        value: 1,
        data: calldata,
      });

      const createdParamsArtifact = require("../../../artifacts/contracts/Test/utils/CreatedParams.sol/CreatedParams.json");
      expect(await evm.getAccountBytecode(CreatedParamsAddress)).to.equal(
        createdParamsArtifact.deployedBytecode
      );
      expect(await evm.getAccountBalance(create2Address)).to.equal(0);
      expect(await evm.getAccountBalance(CreatedParamsAddress)).to.equal(1);
    });

    it("Should be able to call the newly created contract", async function () {
      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: CreatedParamsAddress,
        value: 0,
        data: CreatedParamsFactory.interface.encodeFunctionData("value"),
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["uint256"], [2])
      );
    });

    it("Should forward the revert if the constructor code reverts", async function () {
      CreatedParamsAddress = await evm.getNextDeploymentAddress(
        create2Address
      );

      const calldata = Create2Factory.interface.encodeFunctionData("create2", [
        CreatedParamsFactory.bytecode,
        0,
      ]);

      await expect(
        evm.callStatic.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: create2Address,
          value: 0,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should not allow a create that would overwrite an existing account", async function () {
      CreatedParamsAddress = ethers.utils.getCreate2Address(
        create2Address,
        ethers.utils.hexZeroPad(ethers.utils.hexlify(2), 32),
        ethers.utils.keccak256(
          CreatedParamsFactory.getDeployTransaction(2).data
        )
      );

      const calldata = Create2Factory.interface.encodeFunctionData("create2", [
        CreatedParamsFactory.getDeployTransaction(2).data,
        2,
      ]);

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: create2Address,
          value: 0,
          data: calldata,
        })
      ).to.be.revertedWith("sEVM: account already exists");
    });

    it("Should not allow create while in a readonly context", async function () {
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
        _evm.create2(
          {
            origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegator: ethers.constants.AddressZero,
            to: ethers.constants.AddressZero,
            value: 0,
            data: "0x",
          },
          true,
          0,
          {
            from: impersonatedSigner.address,
          }
        )
      ).to.be.revertedWith("sEVM: read only");
    });
  });
}

module.exports = {
  testCreate2,
};
