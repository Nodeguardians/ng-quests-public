const { expect } = require("chai");
const { ethers } = require("hardhat");

function testCreate(subsuiteName) {
  describe(subsuiteName, function () {
    let evm;

    let createAddress;
    let CreatedNoParamsAddress;
    let CreatedParamsAddress;

    let CreateFactory;
    let CreatedNoParamsFactory;
    let CreatedParamsFactory;

    before(async function () {
      const evmFactory = await ethers.getContractFactory("sEVM");

      evm = await evmFactory.deploy();
      await evm.deployed();
      await evm.createAccount("0xc0ffee254729296a45a3885639AC7E10F9d54979", 10);

      CreateFactory = await ethers.getContractFactory("Create");
      CreatedNoParamsFactory = await ethers.getContractFactory(
        "CreatedNoParams"
      );
      CreatedParamsFactory = await ethers.getContractFactory("CreatedParams");
    });

    it("Should correctly deploy the Create contract", async function () {
      createAddress = await evm.getNextDeploymentAddress(
        "0xc0ffee254729296a45a3885639AC7E10F9d54979"
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: ethers.constants.AddressZero,
        value: 0,
        data: CreateFactory.getDeployTransaction().data,
      });

      const createArtifact = require("../../../artifacts/contracts/test/utils/Create.sol/Create.json");
      expect(await evm.getAccountBytecode(createAddress)).to.equal(
        createArtifact.deployedBytecode
      );
    });

    it("Should be able to create a new contract with no parameters and no value", async function () {
      CreatedNoParamsAddress = await evm.getNextDeploymentAddress(
        createAddress
      );

      const calldata = CreateFactory.interface.encodeFunctionData("create", [
        CreatedNoParamsFactory.bytecode,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: createAddress,
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
        to: createAddress,
        value: 0,
        data: calldata,
      });

      const createdNoParamsArtifact = require("../../../artifacts/contracts/test/utils/CreatedNoParams.sol/CreatedNoParams.json");
      expect(await evm.getAccountBytecode(CreatedNoParamsAddress)).to.equal(
        createdNoParamsArtifact.deployedBytecode
      );
    });

    it("Should increment the nonce of the creator contract", async function () {
      expect(await evm.getAccountNonce(createAddress)).to.equal(2);
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
      CreatedNoParamsAddress = await evm.getNextDeploymentAddress(
        createAddress
      );

      const calldata = CreateFactory.interface.encodeFunctionData("create", [
        CreatedNoParamsFactory.bytecode,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: createAddress,
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
        to: createAddress,
        value: 1,
        data: calldata,
      });

      const createdNoParamsArtifact = require("../../../artifacts/contracts/test/utils/CreatedNoParams.sol/CreatedNoParams.json");
      expect(await evm.getAccountBytecode(CreatedNoParamsAddress)).to.equal(
        createdNoParamsArtifact.deployedBytecode
      );

      expect(await evm.getAccountBalance(createAddress)).to.equal(0);
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
      CreatedParamsAddress = await evm.getNextDeploymentAddress(createAddress);

      const calldata = CreateFactory.interface.encodeFunctionData("create", [
        CreatedParamsFactory.getDeployTransaction(2).data,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: createAddress,
        value: 0,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["address"], [CreatedParamsAddress])
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: createAddress,
        value: 0,
        data: calldata,
      });

      const createdParamsArtifact = require("../../../artifacts/contracts/test/utils/CreatedParams.sol/CreatedParams.json");
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
      CreatedParamsAddress = await evm.getNextDeploymentAddress(createAddress);

      const calldata = CreateFactory.interface.encodeFunctionData("create", [
        CreatedParamsFactory.getDeployTransaction(2).data,
      ]);

      const result = await evm.callStatic.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: createAddress,
        value: 1,
        data: calldata,
      });

      expect(result).to.equal(
        ethers.utils.defaultAbiCoder.encode(["address"], [CreatedParamsAddress])
      );

      await evm.execute({
        caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
        to: createAddress,
        value: 1,
        data: calldata,
      });

      const createdParamsArtifact = require("../../../artifacts/contracts/test/utils/CreatedParams.sol/CreatedParams.json");
      expect(await evm.getAccountBytecode(CreatedParamsAddress)).to.equal(
        createdParamsArtifact.deployedBytecode
      );
      expect(await evm.getAccountBalance(createAddress)).to.equal(0);
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
      CreatedParamsAddress = await evm.getNextDeploymentAddress(createAddress);

      const calldata = CreateFactory.interface.encodeFunctionData("create", [
        CreatedParamsFactory.bytecode,
      ]);

      await expect(
        evm.callStatic.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: createAddress,
          value: 0,
          data: calldata,
        })
      ).to.be.reverted;
    });

    it("Should not allow a create that would overwrite an existing account", async function () {
      CreatedParamsAddress = await evm.getNextDeploymentAddress(createAddress);

      await evm.createAccount(CreatedParamsAddress, 0);

      const calldata = CreateFactory.interface.encodeFunctionData("create", [
        CreatedParamsFactory.getDeployTransaction(2).data,
      ]);

      await expect(
        evm.execute({
          caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
          to: createAddress,
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
        _evm.create(
          {
            origin: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            caller: "0xc0ffee254729296a45a3885639AC7E10F9d54979",
            delegator: ethers.constants.AddressZero,
            to: ethers.constants.AddressZero,
            value: 0,
            data: "0x",
          },
          true,
          {
            from: impersonatedSigner.address,
          }
        )
      ).to.be.revertedWith("sEVM: read only");
    });
  });
}

module.exports = {
  testCreate,
};
