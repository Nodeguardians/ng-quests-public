const { ethers } = require("hardhat");
const { expect } = require("chai");

function testInstructions(subsuiteName, input) {
  describe(subsuiteName, function () {
    let testProbe;

    before(async function () {
      const testProbeFactory = await ethers.getContractFactory(
        "TestProbeInstructions"
      );
      testProbe = await testProbeFactory.deploy();
      await testProbe.deployed();
    });

    it("Should correclty implement the STOP opcode", async function () {
      await testProbe._testStop();
    });

    it("Should correctly implement the arithmetic opcodes", async function () {
      await testAdd(input, testProbe);
      await testSub(input, testProbe);
      await testMul(input, testProbe);
      await testDiv(input, testProbe);
      await testSdiv(input, testProbe);
      await testMod(input, testProbe);
      await testSmod(input, testProbe);
      await testAddmod(input, testProbe);
      await testMulmod(input, testProbe);
      await testExp(input, testProbe);
      await testSignExtend(input, testProbe);
    });

    it("Should correctly implement the comparison opcodes", async function () {
      await testLt(input, testProbe);
      await testGt(input, testProbe);
      await testSlt(input, testProbe);
      await testSgt(input, testProbe);
      await testEq(input, testProbe);
      await testIszero(input, testProbe);
    });

    it("Should correctly implement the bitwise opcodes", async function () {
      await testAnd(input, testProbe);
      await testOr(input, testProbe);
      await testXor(input, testProbe);
      await testNot(input, testProbe);
      await testByte(input, testProbe);
      await testShl(input, testProbe);
      await testShr(input, testProbe);
      await testSar(input, testProbe);
    });

    it("Should correctly implement the INVALID opcode", async function () {
      await testProbe._testInvalid();
    });

    it("Should correctly implement the SHA3 opcode", async function () {
      const offset = ethers.BigNumber.from(input.sha3.offset);
      const data = ethers.BigNumber.from(input.sha3.data);
      await testProbe._testSha3(offset, data);
    });

    it("Should correctly implement the ADDRESS opcode", async function () {
      await testProbe._testAddress(input.address.self);
    });

    it("Should correctly implement the BALANCE opcode", async function () {
      const address = input.balance.address;
      const balance = ethers.BigNumber.from(input.balance.balance);
      await testProbe._testBalance(address, balance);
    });

    it("Should correctly implement the ORIGIN opcode", async function () {
      const address = input.origin.address;
      await testProbe._testOrigin(address);
    });

    it("Should correctly implement the CALLER opcode", async function () {
      const address = input.origin.address;
      await testProbe._testCaller(address);
    });

    it("Should correctly implement the CALLVALUE opcode", async function () {
      const value = ethers.BigNumber.from(input.callvalue.value);
      await testProbe._testCallValue(value);
    });

    it("Should correctly implement the CALLDATALOAD opcode", async function () {
      const calldata = input.calldataload.calldata;
      const offset = ethers.BigNumber.from(input.calldataload.offset);
      await testProbe._testCallDataLoad(calldata, offset);
    });

    it("Should correctly implement the CALLDATASIZE opeocde", async function () {
      const size = input.calldatasize.size;
      await testProbe._testCallDataSize(size);
    });

    it("Should correctly implement the CALLDATACOPY opcode", async function () {
      const calldata = input.calldatacopy.calldata;
      const offset = ethers.BigNumber.from(input.calldatacopy.offset);
      const dst = ethers.BigNumber.from(input.calldatacopy.dst);
      const length = ethers.BigNumber.from(input.calldatacopy.length);

      await testProbe._testCallDataCopy(calldata, dst, offset, length);
    });

    it("Should correctly implement the CODESIZE opcode", async function () {
      const size = ethers.BigNumber.from(input.codesize.size);
      await testProbe._testCodeSize(size);
    });

    it("Should correctly implement the CODECOPY opcode", async function () {
      const bytecode = input.codecopy.bytecode;
      const dst = ethers.BigNumber.from(input.codecopy.dst);
      const offset = ethers.BigNumber.from(input.codecopy.offset);
      const length = ethers.BigNumber.from(input.codecopy.length);
      await testProbe._testCodeCopy(bytecode, dst, offset, length);
    });

    it("Should correctly implement the EXTCODESIZE opcode", async function () {
      const size = ethers.BigNumber.from(input.extcodesize.size);
      const address = input.extcodesize.address;
      await testProbe._testExtCodeSize(address, size);
    });

    it("Should correctly implement the EXTCODECOPY opcode", async function () {
      const address = input.extcodecopy.address;
      const bytecode = input.codecopy.bytecode;
      const dst = ethers.BigNumber.from(input.codecopy.dst);
      const offset = ethers.BigNumber.from(input.codecopy.offset);
      const length = ethers.BigNumber.from(input.codecopy.length);
      await testProbe._testExtCodeCopy(address, bytecode, dst, offset, length);
    });

    it("Should correctly implement the RETURNDATASIZE opcode", async function () {
      const size = ethers.BigNumber.from(input.returndatasize.size);
      await testProbe._testReturnDataSize(size);
    });

    it("Should correctly implement the RETURNDATACOPY opcode", async function () {
      const returndata = input.returndatacopy.data;
      const dst = ethers.BigNumber.from(input.returndatacopy.dst);
      const offset = ethers.BigNumber.from(input.returndatacopy.offset);
      const length = ethers.BigNumber.from(input.returndatacopy.length);
      await testProbe._testReturnDataCopy(returndata, dst, offset, length);
    });

    it("Should correctly implement the EXTCODEHASH opcode", async function () {
      const address = input.extcodecopy.address;
      const bytecode = input.codecopy.bytecode;
      await testProbe._testExtCodeHash(address, bytecode);
    });

    it("Should correctly implement the SELFBALANCE opcode", async function () {
      const address = input.selfbalance.address;
      const balance = ethers.BigNumber.from(input.selfbalance.balance);
      await testProbe._testSelfBalance(address, balance);
    });

    it("Should correctly implement the POP opcode", async function () {
      await testProbe._testPop();
    });

    it("Should correctly implement the MLOAD opcode", async function () {
      const offset = ethers.BigNumber.from(input.mload.offset);
      const value = ethers.BigNumber.from(input.mload.value);
      await testProbe._testMload(offset, value);
    });

    it("Should correctly implement the MSTORE opcode", async function () {
      const offset = ethers.BigNumber.from(input.mstore.offset);
      const value = ethers.BigNumber.from(input.mstore.value);
      await testProbe._testMstore(offset, value);
    });

    it("Should correctly implement the MSTORE8 opcode", async function () {
      const offset = ethers.BigNumber.from(input.mstore8.offset);
      const value = ethers.BigNumber.from(input.mstore8.value);
      await testProbe._testMstore8(offset, value);
    });

    it("Should correctly implement the SLOAD opcode", async function () {
      const key = ethers.BigNumber.from(input.sload.key);
      const value = ethers.BigNumber.from(input.sload.value);
      await testProbe._testSload(key, value);
    });

    it("Should correctly implement the SSTORE opcode", async function () {
      const key = ethers.BigNumber.from(input.sstore.key);
      const value = ethers.BigNumber.from(input.sstore.value);
      const readOnly = input.sstore.readOnly;

      await testProbe._testSstore(key, value, readOnly);
    });

    it("Should correctly implement the JUMP opcode", async function () {
      const pc = ethers.BigNumber.from(input.jump.pc);
      await testProbe._testJump(pc);
    });

    it("Should correctly implement the JUMPI opcode", async function () {
      const pc = ethers.BigNumber.from(input.jumpi.pc);
      const condition = input.jumpi.condition;
      await testProbe._testJumpi(pc, condition);
    });

    it("Should correctly implement the PC opcode", async function () {
      const pc = ethers.BigNumber.from(input.pc.pc);
      await testProbe._testPc(pc);
    });

    it("Should correctly implement the MSIZE opcode", async function () {
      const size = ethers.BigNumber.from(input.msize.size);
      await testProbe._testMsize(size);
    });

    it("Should correctly implement the JUMPDEST opcode", async function () {
      await testProbe._testJumpDest();
    });

    it("Should correctly implement the PUSHN opcodes", async function () {
      await testProbe._testPushN();
    });

    it("Should correctly implement the DUPN opcodes", async function () {
      await testProbe._testDupN();
    });

    it("Should correctly implement the SWAPN opcodes", async function () {
      await testProbe._testSwapN();
    });

    it("Should correctly implement the RETURN opcode", async function () {
      const data = input.return.data;
      const offset = ethers.BigNumber.from(input.return.offset);
      await testProbe._testReturn(data, offset);
    });

    it("Should correctly implement the REVERT opcode", async function () {
      const data = input.revert.data;
      const offset = ethers.BigNumber.from(input.revert.offset);
      await testProbe._testRevert(data, offset);
    });
  });
}

async function testAdd(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.add.lhs);
  const rhs = ethers.BigNumber.from(input.add.rhs);
  await testProbe._testAdd(lhs, rhs);
}

async function testMul(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.mul.lhs);
  const rhs = ethers.BigNumber.from(input.mul.rhs);
  await testProbe._testMul(lhs, rhs);
}

async function testSub(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.sub.lhs);
  const rhs = ethers.BigNumber.from(input.sub.rhs);
  await testProbe._testSub(lhs, rhs);
}

async function testDiv(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.div.lhs);
  const rhs = ethers.BigNumber.from(input.div.rhs);
  await testProbe._testDiv(lhs, rhs);
}

async function testSdiv(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.sdiv.lhs);
  const rhs = ethers.BigNumber.from(input.sdiv.rhs);
  await testProbe._testSdiv(lhs, rhs);
}

async function testMod(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.mod.lhs);
  const rhs = ethers.BigNumber.from(input.mod.rhs);
  await testProbe._testMod(lhs, rhs);
}

async function testSmod(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.smod.lhs);
  const rhs = ethers.BigNumber.from(input.smod.rhs);
  await testProbe._testSmod(lhs, rhs);
}

async function testAddmod(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.addmod.lhs);
  const rhs = ethers.BigNumber.from(input.addmod.rhs);
  const mod = ethers.BigNumber.from(input.addmod.mod);
  await testProbe._testAddMod(lhs, rhs, mod);
}

async function testMulmod(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.mulmod.lhs);
  const rhs = ethers.BigNumber.from(input.mulmod.rhs);
  const mod = ethers.BigNumber.from(input.mulmod.mod);
  await testProbe._testMulMod(lhs, rhs, mod);
}

async function testExp(input, testProbe) {
  const base = ethers.BigNumber.from(input.exp.base);
  const exponent = ethers.BigNumber.from(input.exp.exponent);
  await testProbe._testExp(base, exponent);
}

async function testSignExtend(input, testProbe) {
  const value = ethers.BigNumber.from(input.signextend.value);
  const nBytes = ethers.BigNumber.from(input.signextend.nBytes);
  await testProbe._testSignExtend(value, nBytes);
}

async function testLt(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.lt.lhs);
  const rhs = ethers.BigNumber.from(input.lt.rhs);
  await testProbe._testLt(lhs, rhs);
}

async function testGt(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.gt.lhs);
  const rhs = ethers.BigNumber.from(input.gt.rhs);
  await testProbe._testGt(lhs, rhs);
}

async function testSlt(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.slt.lhs);
  const rhs = ethers.BigNumber.from(input.slt.rhs);
  await testProbe._testSlt(lhs, rhs);
}

async function testSgt(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.sgt.lhs);
  const rhs = ethers.BigNumber.from(input.sgt.rhs);
  await testProbe._testSgt(lhs, rhs);
}

async function testEq(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.eq.lhs);
  const rhs = ethers.BigNumber.from(input.eq.rhs);
  await testProbe._testEq(lhs, rhs);
}

async function testIszero(input, testProbe) {
  const value = ethers.BigNumber.from(input.iszero.value);
  await testProbe._testIsZero(value);
}

async function testAnd(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.and.lhs);
  const rhs = ethers.BigNumber.from(input.and.rhs);
  await testProbe._testAnd(lhs, rhs);
}

async function testOr(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.or.lhs);
  const rhs = ethers.BigNumber.from(input.or.rhs);
  await testProbe._testOr(lhs, rhs);
}

async function testXor(input, testProbe) {
  const lhs = ethers.BigNumber.from(input.xor.lhs);
  const rhs = ethers.BigNumber.from(input.xor.rhs);
  await testProbe._testXor(lhs, rhs);
}

async function testNot(input, testProbe) {
  const value = ethers.BigNumber.from(input.not.value);
  await testProbe._testNot(value);
}

async function testByte(input, testProbe) {
  const value = ethers.BigNumber.from(input.byte.value);
  const index = ethers.BigNumber.from(input.byte.index);
  await testProbe._testByte(value, index);
}

async function testShl(input, testProbe) {
  const value = ethers.BigNumber.from(input.shl.value);
  const shift = ethers.BigNumber.from(input.shl.shift);
  await testProbe._testShl(value, shift);
}

async function testShr(input, testProbe) {
  const value = ethers.BigNumber.from(input.shr.value);
  const shift = ethers.BigNumber.from(input.shr.shift);
  await testProbe._testShr(value, shift);
}

async function testSar(input, testProbe) {
  const value = ethers.BigNumber.from(input.sar.value);
  const shift = ethers.BigNumber.from(input.sar.shift);
  await testProbe._testSar(value, shift);
}

module.exports = {
  testInstructions,
};
