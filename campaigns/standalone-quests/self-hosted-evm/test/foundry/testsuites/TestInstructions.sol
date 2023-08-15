// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "contracts/test/TestProbeInstructions.sol";
import "forge-std/Test.sol";

abstract contract TestInstructions is TestProbeInstructions, Test {
    using stdJson for string;

    struct UnsignedArithmetic {
        uint256 lhs;
        uint256 rhs;
    }

    struct SignedArithmetic {
        int256 lhs;
        int256 rhs;
    }

    struct Mod {
        uint256 lhs;
        uint256 rhs;
        uint256 mod;
    }

    struct Exp {
        uint256 base;
        uint256 exponent;
    }

    struct SignExtend {
        int256 value;
        uint256 nBytes0;
    }

    struct Value {
        uint256 value;
    }

    struct Byte {
        uint256 value;
        uint256 index;
    }

    struct Shift {
        uint256 value;
        uint256 shift;
    }

    struct SignedShift {
        int256 value;
        uint256 shift;
    }

    struct DataOffset {
        uint256 offset;
        bytes data;
    }

    struct Address {
        address addr;
    }

    struct Balance {
        address addr;
        uint256 balance;
    }

    struct DataCopy {
        bytes data;
        uint256 dst;
        uint256 length;
        uint256 offset;
    }

    struct ExtCodeSize {
        address addr;
        uint256 size;
    }

    struct ExtCodeCopy {
        address addr;
        bytes bytecode;
        uint256 dst;
        uint256 length;
        uint256 offset;
    }

    struct ExtCodeHash {
        address addr;
        bytes bytecode;
    }

    struct MemoryRW {
        uint256 offset;
        uint256 value;
    }

    struct Sload {
        uint256 key;
        uint256 value;
    }

    struct Sstore {
        uint256 key;
        bool readOnly;
        uint256 value;
    }

    struct JumpI {
        bool condition;
        uint256 pc;
    }

    struct Inputs {
        UnsignedArithmetic add;
        Mod addmod;
        Address address_;
        UnsignedArithmetic and;
        Balance balance;
        Byte _byte;
        DataCopy callDataCopy;
        DataOffset callDataLoad;
        Value callDataSize;
        Address caller;
        Value callValue;
        DataCopy codeCopy;
        Value codeSize;
        UnsignedArithmetic div;
        UnsignedArithmetic eq;
        Exp exp;
        ExtCodeCopy extCodeCopy;
        ExtCodeHash extCodeHash;
        ExtCodeSize extCodeSize;
        UnsignedArithmetic gt;
        Value isZero;
        Value jump;
        JumpI jumpi;
        UnsignedArithmetic lt;
        MemoryRW mload;
        UnsignedArithmetic mod;
        Value msize;
        MemoryRW mstore;
        MemoryRW mstore8;
        UnsignedArithmetic mul;
        Mod mulmod;
        Value not;
        UnsignedArithmetic or;
        Address origin;
        Value pc;
        DataOffset return_;
        DataCopy returndatacopy;
        Value returndatasize;
        DataOffset revert_;
        SignedShift sar;
        SignedArithmetic sdiv;
        Balance selfBalance;
        SignedArithmetic sgt;
        DataOffset sha3;
        Shift shl;
        Shift shr;
        SignExtend signExtend;
        Sload sload;
        SignedArithmetic slt;
        SignedArithmetic smod;
        Sstore sstore;
        UnsignedArithmetic sub;
        UnsignedArithmetic xor;
        //
    }

    Inputs inputs;

    function setUp() public {}

    constructor(string memory path, string memory key) {
        string memory data = vm.readFile(path);

        inputs.add = abi.decode(
            data.parseRaw(string.concat(key, ".add")),
            (UnsignedArithmetic)
        );
        inputs.sub = abi.decode(
            data.parseRaw(string.concat(key, ".sub")),
            (UnsignedArithmetic)
        );
        inputs.mul = abi.decode(
            data.parseRaw(string.concat(key, ".mul")),
            (UnsignedArithmetic)
        );
        inputs.div = abi.decode(
            data.parseRaw(string.concat(key, ".div")),
            (UnsignedArithmetic)
        );
        inputs.sdiv = abi.decode(
            data.parseRaw(string.concat(key, ".sdiv")),
            (SignedArithmetic)
        );
        inputs.mod = abi.decode(
            data.parseRaw(string.concat(key, ".mod")),
            (UnsignedArithmetic)
        );
        inputs.smod = abi.decode(
            data.parseRaw(string.concat(key, ".smod")),
            (SignedArithmetic)
        );
        inputs.addmod = abi.decode(
            data.parseRaw(string.concat(key, ".addmod")),
            (Mod)
        );
        inputs.mulmod = abi.decode(
            data.parseRaw(string.concat(key, ".mulmod")),
            (Mod)
        );
        inputs.exp = abi.decode(
            data.parseRaw(string.concat(key, ".exp")),
            (Exp)
        );
        inputs.signExtend = abi.decode(
            data.parseRaw(string.concat(key, ".signextend")),
            (SignExtend)
        );
        inputs.lt = abi.decode(
            data.parseRaw(string.concat(key, ".lt")),
            (UnsignedArithmetic)
        );
        inputs.gt = abi.decode(
            data.parseRaw(string.concat(key, ".gt")),
            (UnsignedArithmetic)
        );
        inputs.slt = abi.decode(
            data.parseRaw(string.concat(key, ".slt")),
            (SignedArithmetic)
        );
        inputs.sgt = abi.decode(
            data.parseRaw(string.concat(key, ".sgt")),
            (SignedArithmetic)
        );
        inputs.eq = abi.decode(
            data.parseRaw(string.concat(key, ".eq")),
            (UnsignedArithmetic)
        );

        inputs.isZero = abi.decode(
            data.parseRaw(string.concat(key, ".iszero")),
            (Value)
        );

        inputs.and = abi.decode(
            data.parseRaw(string.concat(key, ".and")),
            (UnsignedArithmetic)
        );

        inputs.or = abi.decode(
            data.parseRaw(string.concat(key, ".or")),
            (UnsignedArithmetic)
        );

        inputs.xor = abi.decode(
            data.parseRaw(string.concat(key, ".xor")),
            (UnsignedArithmetic)
        );

        inputs.not = abi.decode(
            data.parseRaw(string.concat(key, ".not")),
            (Value)
        );

        inputs._byte = abi.decode(
            data.parseRaw(string.concat(key, ".byte")),
            (Byte)
        );

        inputs.shl = abi.decode(
            data.parseRaw(string.concat(key, ".shl")),
            (Shift)
        );

        inputs.shr = abi.decode(
            data.parseRaw(string.concat(key, ".shr")),
            (Shift)
        );

        inputs.sar = abi.decode(
            data.parseRaw(string.concat(key, ".sar")),
            (SignedShift)
        );

        inputs.sha3 = abi.decode(
            data.parseRaw(string.concat(key, ".sha3")),
            (DataOffset)
        );

        inputs.address_ = abi.decode(
            data.parseRaw(string.concat(key, ".address")),
            (Address)
        );

        inputs.balance = abi.decode(
            data.parseRaw(string.concat(key, ".balance")),
            (Balance)
        );

        inputs.origin = abi.decode(
            data.parseRaw(string.concat(key, ".origin")),
            (Address)
        );

        inputs.caller = abi.decode(
            data.parseRaw(string.concat(key, ".caller")),
            (Address)
        );

        inputs.callValue = abi.decode(
            data.parseRaw(string.concat(key, ".callvalue")),
            (Value)
        );

        inputs.callDataLoad = abi.decode(
            data.parseRaw(string.concat(key, ".calldataload")),
            (DataOffset)
        );

        inputs.callDataSize = abi.decode(
            data.parseRaw(string.concat(key, ".calldatasize")),
            (Value)
        );

        inputs.callDataCopy = abi.decode(
            data.parseRaw(string.concat(key, ".calldatacopy")),
            (DataCopy)
        );

        inputs.codeSize = abi.decode(
            data.parseRaw(string.concat(key, ".codesize")),
            (Value)
        );

        inputs.codeCopy = abi.decode(
            data.parseRaw(string.concat(key, ".codecopy")),
            (DataCopy)
        );

        inputs.extCodeSize = abi.decode(
            data.parseRaw(string.concat(key, ".extcodesize")),
            (ExtCodeSize)
        );

        inputs.extCodeCopy = abi.decode(
            data.parseRaw(string.concat(key, ".extcodecopy")),
            (ExtCodeCopy)
        );

        inputs.returndatasize = abi.decode(
            data.parseRaw(string.concat(key, ".returndatasize")),
            (Value)
        );

        inputs.returndatacopy = abi.decode(
            data.parseRaw(string.concat(key, ".returndatacopy")),
            (DataCopy)
        );

        inputs.extCodeHash = abi.decode(
            data.parseRaw(string.concat(key, ".extcodehash")),
            (ExtCodeHash)
        );

        inputs.selfBalance = abi.decode(
            data.parseRaw(string.concat(key, ".selfbalance")),
            (Balance)
        );

        inputs.mload = abi.decode(
            data.parseRaw(string.concat(key, ".mload")),
            (MemoryRW)
        );

        inputs.mstore = abi.decode(
            data.parseRaw(string.concat(key, ".mstore")),
            (MemoryRW)
        );

        inputs.mstore8 = abi.decode(
            data.parseRaw(string.concat(key, ".mstore8")),
            (MemoryRW)
        );

        inputs.sload = abi.decode(
            data.parseRaw(string.concat(key, ".sload")),
            (Sload)
        );

        inputs.sstore = abi.decode(
            data.parseRaw(string.concat(key, ".sstore")),
            (Sstore)
        );

        inputs.jump = abi.decode(
            data.parseRaw(string.concat(key, ".jump")),
            (Value)
        );

        inputs.jumpi = abi.decode(
            data.parseRaw(string.concat(key, ".jumpi")),
            (JumpI)
        );

        inputs.pc = abi.decode(
            data.parseRaw(string.concat(key, ".pc")),
            (Value)
        );

        inputs.msize = abi.decode(
            data.parseRaw(string.concat(key, ".msize")),
            (Value)
        );

        inputs.return_ = abi.decode(
            data.parseRaw(string.concat(key, ".return")),
            (DataOffset)
        );

        inputs.revert_ = abi.decode(
            data.parseRaw(string.concat(key, ".revert")),
            (DataOffset)
        );
    }

    function _test_Add() internal view {
        uint256 lhs = inputs.add.lhs;
        uint256 rhs = inputs.add.rhs;

        _testAdd(lhs, rhs);
    }

    function _test_Sub() internal view {
        uint256 lhs = inputs.sub.lhs;
        uint256 rhs = inputs.sub.rhs;
        _testSub(lhs, rhs);
    }

    function _test_Div() internal view {
        uint256 lhs = inputs.div.lhs;
        uint256 rhs = inputs.div.rhs;
        _testDiv(lhs, rhs);
    }

    function _test_Sdiv() internal view {
        int256 lhs = inputs.sdiv.lhs;
        int256 rhs = inputs.sdiv.rhs;
        _testSdiv(lhs, rhs);
    }

    function _test_Mul() internal view {
        uint256 lhs = inputs.mul.lhs;
        uint256 rhs = inputs.mul.rhs;
        _testMul(lhs, rhs);
    }

    function _test_Smod() internal view {
        int256 lhs = inputs.smod.lhs;
        int256 rhs = inputs.smod.rhs;
        _testSmod(lhs, rhs);
    }

    function _test_Mod() internal view {
        uint256 lhs = inputs.mod.lhs;
        uint256 rhs = inputs.mod.rhs;
        _testMod(lhs, rhs);
    }

    function _test_Addmod() internal view {
        uint256 lhs = inputs.addmod.lhs;
        uint256 rhs = inputs.addmod.rhs;
        uint256 mod = inputs.addmod.mod;
        _testAddMod(lhs, rhs, mod);
    }

    function _test_Mulmod() internal view {
        uint256 lhs = inputs.mulmod.lhs;
        uint256 rhs = inputs.mulmod.rhs;
        uint256 mod = inputs.mulmod.mod;
        _testMulMod(lhs, rhs, mod);
    }

    function _test_Exp() internal view {
        uint256 base = inputs.exp.base;
        uint256 exponent = inputs.exp.exponent;
        _testExp(base, exponent);
    }

    function _test_SignExtend() internal view {
        int256 value = inputs.signExtend.value;
        uint256 nBytes0 = inputs.signExtend.nBytes0;
        _testSignExtend(value, nBytes0);
    }

    function test_Arithmetic() external view {
        _test_Add();
        _test_Sub();
        _test_Div();
        _test_Sdiv();
        _test_Mul();
        _test_Smod();
        _test_Mod();
        _test_Addmod();
        _test_Mulmod();
        _test_Exp();
        _test_SignExtend();
    }

    function _test_Lt() internal view {
        uint256 lhs = inputs.lt.lhs;
        uint256 rhs = inputs.lt.rhs;
        _testLt(lhs, rhs);
    }

    function _test_Gt() internal view {
        uint256 lhs = inputs.gt.lhs;
        uint256 rhs = inputs.gt.rhs;
        _testGt(lhs, rhs);
    }

    function _test_Slt() internal view {
        int256 lhs = inputs.slt.lhs;
        int256 rhs = inputs.slt.rhs;
        _testSlt(lhs, rhs);
    }

    function _test_Sgt() internal view {
        int256 lhs = inputs.sgt.lhs;
        int256 rhs = inputs.sgt.rhs;
        _testSgt(lhs, rhs);
    }

    function _test_Eq() internal view {
        uint256 lhs = inputs.eq.lhs;
        uint256 rhs = inputs.eq.rhs;
        _testEq(lhs, rhs);
    }

    function _test_IsZero() internal view {
        uint256 value = inputs.isZero.value;
        _testIsZero(value);
    }

    function test_Comparison() external view {
        _test_Lt();
        _test_Gt();
        _test_Slt();
        _test_Sgt();
        _test_Eq();
        _test_IsZero();
    }

    function _test_And() internal view {
        uint256 lhs = inputs.and.lhs;
        uint256 rhs = inputs.and.rhs;
        _testAnd(lhs, rhs);
    }

    function _test_Or() internal view {
        uint256 lhs = inputs.or.lhs;
        uint256 rhs = inputs.or.rhs;
        _testOr(lhs, rhs);
    }

    function _test_Xor() internal view {
        uint256 lhs = inputs.xor.lhs;
        uint256 rhs = inputs.xor.rhs;
        _testXor(lhs, rhs);
    }

    function _test_Not() internal view {
        uint256 value = inputs.not.value;
        _testNot(value);
    }

    function _test_Byte() internal view {
        uint256 value = inputs._byte.value;
        uint256 index = inputs._byte.index;
        _testByte(value, index);
    }

    function _test_Shl() internal view {
        uint256 value = inputs.shl.value;
        uint256 shift = inputs.shl.shift;
        _testShl(value, shift);
    }

    function _test_Shr() internal view {
        uint256 value = inputs.shr.value;
        uint256 shift = inputs.shr.shift;
        _testShr(value, shift);
    }

    function _test_Sar() internal view {
        int256 value = inputs.sar.value;
        uint256 shift = inputs.sar.shift;
        _testSar(value, shift);
    }

    function test_Bitwise() external view {
        _test_And();
        _test_Or();
        _test_Xor();
        _test_Not();
        _test_Byte();
        _test_Shl();
        _test_Shr();
        _test_Sar();
    }

    function test_Invalid() external pure {
        _testInvalid();
    }

    function test_Sha3() external view {
        uint256 offset = inputs.sha3.offset;
        bytes memory data = inputs.sha3.data;

        _testSha3(offset, data);
    }

    function test_Address() external view {
        address self = inputs.address_.addr;
        _testAddress(self);
    }

    function test_Balance() external {
        address addr = inputs.balance.addr;
        uint256 balance = inputs.balance.balance;
        _testBalance(addr, balance);
    }

    function test_Origin() external view {
        address origin = inputs.origin.addr;
        _testOrigin(origin);
    }

    function test_Caller() external view {
        address caller = inputs.caller.addr;
        _testCaller(caller);
    }

    function test_CallValue() external view {
        uint256 value = inputs.callValue.value;
        _testCallValue(value);
    }

    function test_CallDataLoad() external view {
        uint256 offset = inputs.callDataLoad.offset;
        bytes memory data = inputs.callDataLoad.data;
        _testCallDataLoad(data, offset);
    }

    function test_CallDataSize() external view {
        uint256 size = inputs.callDataSize.value;
        _testCallDataSize(size);
    }

    function test_CallDataCopy() external view {
        uint256 offset = inputs.callDataCopy.offset;
        uint256 length = inputs.callDataCopy.length;
        uint256 dst = inputs.callDataCopy.dst;
        bytes memory data = inputs.callDataCopy.data;

        _testCallDataCopy(data, dst, offset, length);
    }

    function test_CodeSize() external view {
        uint256 size = inputs.codeSize.value;
        _testCodeSize(size);
    }

    function test_CodeCopy() external view {
        uint256 offset = inputs.codeCopy.offset;
        uint256 length = inputs.codeCopy.length;
        uint256 dst = inputs.codeCopy.dst;
        bytes memory data = inputs.codeCopy.data;

        _testCodeCopy(data, dst, offset, length);
    }

    function test_ExtCodeSize() external {
        address addr = inputs.extCodeSize.addr;
        uint256 size = inputs.extCodeSize.size;
        _testExtCodeSize(addr, size);
    }

    function test_ExtCodeCopy() external {
        address addr = inputs.extCodeCopy.addr;
        uint256 offset = inputs.extCodeCopy.offset;
        uint256 length = inputs.extCodeCopy.length;
        uint256 dst = inputs.extCodeCopy.dst;
        bytes memory data = inputs.extCodeCopy.bytecode;

        _testExtCodeCopy(addr, data, dst, offset, length);
    }

    function test_ReturnDataSize() external view {
        uint256 size = inputs.returndatasize.value;
        _testReturnDataSize(size);
    }

    function test_ReturnDataCopy() external view {
        uint256 offset = inputs.returndatacopy.offset;
        uint256 length = inputs.returndatacopy.length;
        uint256 dst = inputs.returndatacopy.dst;
        bytes memory data = inputs.returndatacopy.data;

        _testReturnDataCopy(data, dst, offset, length);
    }

    function test_ExtCodeHash() external {
        address addr = inputs.extCodeHash.addr;
        bytes memory bytecode = inputs.extCodeHash.bytecode;

        _testExtCodeHash(addr, bytecode);
    }

    function test_SelfBalance() external {
        address addr = inputs.selfBalance.addr;
        uint256 balance = inputs.selfBalance.balance;
        _testSelfBalance(addr, balance);
    }

    function test_Mload() external view {
        uint256 offset = inputs.mload.offset;
        uint256 value = inputs.mload.value;
        _testMload(offset, value);
    }

    function test_Mstore() external view {
        uint256 offset = inputs.mstore.offset;
        uint256 value = inputs.mstore.value;
        _testMstore(offset, value);
    }

    function test_Mstore8() external view {
        uint256 offset = inputs.mstore8.offset;
        uint256 value = inputs.mstore8.value;
        _testMstore8(offset, uint8(value));
    }

    function test_Sload() external {
        uint256 key = inputs.sload.key;
        uint256 value = inputs.sload.value;

        _testSload(key, value);
    }

    function test_Sstore() external {
        uint256 key = inputs.sstore.key;
        uint256 value = inputs.sstore.value;
        bool readOnly = inputs.sstore.readOnly;

        _testSstore(key, value, readOnly);
    }

    function test_Jump() external view {
        uint256 pc = inputs.jump.value;
        _testJump(pc);
    }

    function test_Jumpi() external view {
        uint256 pc = inputs.jumpi.pc;
        bool condition = inputs.jumpi.condition;

        _testJumpi(pc, condition);
    }

    function test_JumpDest() external pure {
        _testJumpDest();
    }

    function test_PushN() external pure {
        _testPushN();
    }

    function test_DupN() external pure {
        _testDupN();
    }

    function test_SwapN() external pure {
        _testSwapN();
    }

    function test_Pc() external view {
        uint256 pc = inputs.pc.value;
        _testPc(pc);
    }

    function test_Msize() external view {
        uint256 size = inputs.msize.value;
        _testMsize(size);
    }

    function test_Return() external view {
        uint256 offset = inputs.return_.offset;
        bytes memory data = inputs.return_.data;

        _testReturn(data, offset);
    }

    function test_Revert() external view {
        uint256 offset = inputs.revert_.offset;
        bytes memory data = inputs.revert_.data;

        _testRevert(data, offset);
    }
}
