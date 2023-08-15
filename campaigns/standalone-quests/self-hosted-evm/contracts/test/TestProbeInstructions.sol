// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "../libraries/Context.sol";
import "../libraries/Memory.sol";
import "../libraries/Stack.sol";
import "../libraries/Instructions.sol";
import "../libraries/Opcodes.sol";
import "../sEVM.sol";

contract TestProbeInstructions is sEVM {
    using StackLib for Stack;
    using MemoryLib for Memory;

    function getAPI() internal pure returns (API memory) {
        API memory api = API({
            getAccount: getAccount,
            getAccountBalance: getAccountBalance,
            getAccountNonce: getAccountNonce,
            getAccountBytecode: getAccountBytecode,
            setAccountBytecode: setAccountBytecode,
            readAccountStorageAt: readAccountStorageAt,
            writeAccountStorageAt: writeAccountStorageAt,
            transfer: transfer
        });

        return api;
    }

    function assertStackDepth(Scope memory scope, uint256 depth) internal pure {
        if (scope.stack.depth != depth) {
            revert("Stack depth is not correct");
        }
    }

    function assertStackPeek(
        Scope memory scope,
        uint256 depth,
        bytes32 value
    ) internal pure {
        if (scope.stack.peek(depth) != value) {
            revert("Stack peek is not correct");
        }
    }

    function getInitialScope() internal pure returns (Scope memory) {
        Scope memory scope;
        scope.stack = StackLib.init(1024);
        scope._memory = Memory({max: 0, mem: new bytes(1024)});
        scope.api = getAPI();
        return scope;
    }

    function _testStop() public pure {
        Scope memory scope = getInitialScope();
        assertStackDepth(scope, 0);
        InstructionsLib.opStop(scope);
        assertStackDepth(scope, 0);

        if (scope.stop != true) {
            revert("Stop flag is not set");
        }
    }

    function _testAdd(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opAdd(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        unchecked {
            result = lhs + rhs;
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSub(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opSub(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        unchecked {
            result = lhs - rhs;
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testDiv(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opDiv(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        unchecked {
            result = lhs / rhs;
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSdiv(int256 lhs, int256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(uint256(lhs));
        bytes32 _rhs = bytes32(uint256(rhs));

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opSDiv(scope);
        assertStackDepth(scope, 1);

        int256 result;

        unchecked {
            result = lhs / rhs;
        }

        assertStackPeek(scope, 0, bytes32(uint256(result)));
    }

    function _testMul(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opMul(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        unchecked {
            result = lhs * rhs;
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testMod(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opMod(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        unchecked {
            result = lhs % rhs;
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSmod(int256 lhs, int256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(uint256(lhs));
        bytes32 _rhs = bytes32(uint256(rhs));

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opSMod(scope);
        assertStackDepth(scope, 1);

        int256 result;

        unchecked {
            result = lhs % rhs;
        }

        assertStackPeek(scope, 0, bytes32(uint256(result)));
    }

    function _testAddMod(uint256 lhs, uint256 rhs, uint256 mod) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);
        bytes32 _mod = bytes32(mod);

        assertStackDepth(scope, 0);

        scope.stack.push(_mod);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _mod);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _rhs);
        assertStackPeek(scope, 1, _mod);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 3);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);
        assertStackPeek(scope, 2, _mod);

        InstructionsLib.opAddMod(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        assembly {
            result := addmod(lhs, rhs, _mod)
        }

        assertStackPeek(scope, 0, bytes32(uint256(result)));
    }

    function _testMulMod(uint256 lhs, uint256 rhs, uint256 mod) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);
        bytes32 _mod = bytes32(mod);

        assertStackDepth(scope, 0);

        scope.stack.push(_mod);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _mod);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _rhs);
        assertStackPeek(scope, 1, _mod);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 3);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);
        assertStackPeek(scope, 2, _mod);

        InstructionsLib.opMulMod(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        assembly {
            result := mulmod(lhs, rhs, _mod)
        }

        assertStackPeek(scope, 0, bytes32(uint256(result)));
    }

    function _testExp(uint256 base, uint256 exponent) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _base = bytes32(base);
        bytes32 _exponent = bytes32(exponent);

        assertStackDepth(scope, 0);

        scope.stack.push(_exponent);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _exponent);

        scope.stack.push(_base);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _base);
        assertStackPeek(scope, 1, _exponent);

        InstructionsLib.opExp(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        unchecked {
            result = base ** exponent;
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSignExtend(int256 value, uint256 nBytes) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(uint256(value));
        bytes32 _nBytes = bytes32(nBytes);

        assertStackDepth(scope, 0);

        scope.stack.push(_nBytes);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _nBytes);

        scope.stack.push(_value);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _value);
        assertStackPeek(scope, 1, _nBytes);

        InstructionsLib.opSignExtend(scope);
        assertStackDepth(scope, 1);

        int256 result;

        assembly {
            result := signextend(value, nBytes)
        }

        assertStackPeek(scope, 0, bytes32(uint256(result)));
    }

    function _testLt(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opLt(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs < rhs ? 1 : 0;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testGt(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opGt(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs > rhs ? 1 : 0;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSlt(int256 lhs, int256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(uint256(lhs));
        bytes32 _rhs = bytes32(uint256(rhs));

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opSlt(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs < rhs ? 1 : 0;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSgt(int256 lhs, int256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(uint256(lhs));
        bytes32 _rhs = bytes32(uint256(rhs));

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opSgt(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs > rhs ? 1 : 0;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testEq(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opEq(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs == rhs ? 1 : 0;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testIsZero(uint256 value) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(value);

        assertStackDepth(scope, 0);

        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);

        InstructionsLib.opIsZero(scope);
        assertStackDepth(scope, 1);

        uint256 result = value == 0 ? 1 : 0;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testAnd(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opAnd(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs & rhs;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testOr(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opOr(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs | rhs;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testXor(uint256 lhs, uint256 rhs) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _lhs = bytes32(lhs);
        bytes32 _rhs = bytes32(rhs);

        assertStackDepth(scope, 0);

        scope.stack.push(_rhs);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _rhs);

        scope.stack.push(_lhs);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _lhs);
        assertStackPeek(scope, 1, _rhs);

        InstructionsLib.opXor(scope);
        assertStackDepth(scope, 1);

        uint256 result = lhs ^ rhs;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testNot(uint256 value) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(value);

        assertStackDepth(scope, 0);

        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);

        InstructionsLib.opNot(scope);
        assertStackDepth(scope, 1);

        uint256 result = ~value;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testByte(uint256 value, uint256 index) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(value);
        bytes32 _index = bytes32(index);

        assertStackDepth(scope, 0);

        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);

        scope.stack.push(_index);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _index);
        assertStackPeek(scope, 1, _value);

        InstructionsLib.opByte(scope);
        assertStackDepth(scope, 1);

        uint256 result;

        assembly {
            result := byte(index, value)
        }

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testShl(uint256 value, uint256 shift) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(value);
        bytes32 _shift = bytes32(shift);

        assertStackDepth(scope, 0);

        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);

        scope.stack.push(_shift);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _shift);
        assertStackPeek(scope, 1, _value);

        InstructionsLib.opShl(scope);
        assertStackDepth(scope, 1);

        uint256 result = value << shift;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testShr(uint256 value, uint256 shift) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(value);
        bytes32 _shift = bytes32(shift);

        assertStackDepth(scope, 0);

        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);

        scope.stack.push(_shift);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _shift);
        assertStackPeek(scope, 1, _value);

        InstructionsLib.opShr(scope);
        assertStackDepth(scope, 1);

        uint256 result = value >> shift;

        assertStackPeek(scope, 0, bytes32(result));
    }

    function _testSar(int256 value, uint256 shift) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _value = bytes32(uint256(value));
        bytes32 _shift = bytes32(shift);

        assertStackDepth(scope, 0);

        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);

        scope.stack.push(_shift);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _shift);
        assertStackPeek(scope, 1, _value);

        InstructionsLib.opSar(scope);
        assertStackDepth(scope, 1);

        int256 result = value >> shift;

        assertStackPeek(scope, 0, bytes32(uint256(result)));
    }

    function _testInvalid() public pure {
        Scope memory scope = getInitialScope();
        assertStackDepth(scope, 0);

        InstructionsLib.opInvalid(scope);
        assertStackDepth(scope, 0);

        require(scope.stop == true, "stop flag not set");
        require(scope.reverted == true, "reverted flag not set");
        require(
            keccak256(scope.returndata) == keccak256("invalid opcode"),
            "returndata not set"
        );
    }

    function _testSha3(uint256 offset, bytes memory data) public pure {
        Scope memory scope = getInitialScope();
        uint256 src;
        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(data.length);

        assembly {
            src := add(data, 0x20)
        }

        scope._memory.inject(src, offset, data.length);
        assertStackDepth(scope, 0);

        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);

        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);

        InstructionsLib.opSha3(scope);
        assertStackDepth(scope, 1);

        bytes32 result = keccak256(data);

        assertStackPeek(scope, 0, result);
    }

    function _testAddress(address self) public pure {
        Scope memory scope = getInitialScope();
        scope._contract = Contract({self: self, bytecode: new bytes(0)});

        assertStackDepth(scope, 0);

        InstructionsLib.opAddress(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(uint256(uint160(address(self)))));
    }

    function _testBalance(address addr, uint256 balance) public {
        Scope memory scope = getInitialScope();

        createAccount(addr, balance);

        bytes32 _addr = bytes32(uint256(uint160(addr)));

        assertStackDepth(scope, 0);
        scope.stack.push(_addr);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _addr);

        InstructionsLib.opBalance(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(balance));
    }

    function _testOrigin(address addr) public pure {
        Scope memory scope = getInitialScope();
        scope.context.origin = addr;

        assertStackDepth(scope, 0);
        InstructionsLib.opOrigin(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(uint256(uint160(addr))));
    }

    function _testCaller(address addr) public pure {
        Scope memory scope = getInitialScope();
        scope.context.caller = addr;

        assertStackDepth(scope, 0);
        InstructionsLib.opCaller(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(uint256(uint160(addr))));
    }

    function _testCallValue(uint256 callvalue) public pure {
        Scope memory scope = getInitialScope();
        scope.context.callvalue = callvalue;

        assertStackDepth(scope, 0);
        InstructionsLib.opCallValue(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(callvalue));
    }

    function _testCallDataLoad(bytes memory data, uint256 offset) public pure {
        Scope memory scope = getInitialScope();

        scope.context._calldata = data;

        assertStackDepth(scope, 0);
        scope.stack.push(bytes32(offset));
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(offset));

        InstructionsLib.opCallDataLoad(scope);
        assertStackDepth(scope, 1);

        bytes32 expected;

        assembly {
            expected := mload(add(add(data, 0x20), offset))
        }

        assertStackPeek(scope, 0, expected);
    }

    function _testCallDataSize(uint256 size) public pure {
        Scope memory scope = getInitialScope();

        scope.context._calldata = new bytes(size);

        InstructionsLib.opCallDataSize(scope);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(size));
    }

    function _testCallDataCopy(
        bytes memory data,
        uint256 dst,
        uint256 offset,
        uint256 length
    ) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _dst = bytes32(dst);
        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(length);

        scope.context._calldata = data;

        assertStackDepth(scope, 0);
        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);

        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);

        scope.stack.push(_dst);
        assertStackDepth(scope, 3);
        assertStackPeek(scope, 0, _dst);
        assertStackPeek(scope, 1, _offset);
        assertStackPeek(scope, 2, _length);

        InstructionsLib.opCallDataCopy(scope);
        assertStackDepth(scope, 0);

        bytes memory copy = scope._memory.extract(dst, length);
        uint256 len = offset + length <= data.length
            ? length
            : data.length - offset;
        bytes memory expected = new bytes(len);

        for (uint256 i; i < len; i++) {
            expected[i] = data[offset + i];
        }

        require(
            keccak256(copy) == keccak256(expected),
            "Invalid calldata copy"
        );
    }

    function _testCodeSize(uint256 size) public pure {
        Scope memory scope = getInitialScope();

        scope._contract.bytecode = new bytes(size);
        assertStackDepth(scope, 0);

        InstructionsLib.opCodeSize(scope);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(size));
    }

    function _testCodeCopy(
        bytes memory bytecode,
        uint256 dst,
        uint256 offset,
        uint256 length
    ) public pure {
        Scope memory scope = getInitialScope();
        bytes32 _dst = bytes32(dst);
        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(length);

        scope._contract.bytecode = bytecode;

        assertStackDepth(scope, 0);
        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);

        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);

        scope.stack.push(_dst);
        assertStackDepth(scope, 3);
        assertStackPeek(scope, 0, _dst);
        assertStackPeek(scope, 1, _offset);
        assertStackPeek(scope, 2, _length);

        InstructionsLib.opCodeCopy(scope);
        assertStackDepth(scope, 0);

        bytes memory copy = scope._memory.extract(dst, length);
        uint256 len = offset + length <= bytecode.length
            ? length
            : bytecode.length - offset;
        bytes memory expected = new bytes(len);

        for (uint256 i; i < len; i++) {
            expected[i] = bytecode[offset + i];
        }

        require(keccak256(copy) == keccak256(expected), "Invalid code copy");
    }

    function _testExtCodeSize(address addr, uint256 size) public {
        Scope memory scope = getInitialScope();

        delete accounts[addr];
        createAccount(addr, 0);
        scope.api.setAccountBytecode(addr, new bytes(size));

        bytes32 _addr = bytes32(uint256(uint160(addr)));

        assertStackDepth(scope, 0);
        scope.stack.push(_addr);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _addr);

        InstructionsLib.opExtCodeSize(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(size));
    }

    function _testExtCodeCopy(
        address addr,
        bytes memory bytecode,
        uint256 dst,
        uint256 offset,
        uint256 length
    ) public {
        Scope memory scope = getInitialScope();

        delete accounts[addr];
        createAccount(addr, 0);
        scope.api.setAccountBytecode(addr, bytecode);

        bytes32 _addr = bytes32(uint256(uint160(addr)));
        bytes32 _dst = bytes32(dst);
        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(length);

        scope._contract.bytecode = bytecode;

        assertStackDepth(scope, 0);
        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);

        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);

        scope.stack.push(_dst);
        assertStackDepth(scope, 3);
        assertStackPeek(scope, 0, _dst);
        assertStackPeek(scope, 1, _offset);
        assertStackPeek(scope, 2, _length);

        scope.stack.push(_addr);
        assertStackDepth(scope, 4);
        assertStackPeek(scope, 0, _addr);
        assertStackPeek(scope, 1, _dst);
        assertStackPeek(scope, 2, _offset);
        assertStackPeek(scope, 3, _length);

        InstructionsLib.opExtCodeCopy(scope);
        assertStackDepth(scope, 0);

        bytes memory copy = scope._memory.extract(dst, length);
        uint256 len = offset + length <= bytecode.length
            ? length
            : bytecode.length - offset;
        bytes memory expected = new bytes(len);

        for (uint256 i; i < len; i++) {
            expected[i] = bytecode[offset + i];
        }

        require(keccak256(copy) == keccak256(expected), "Invalid code copy");
    }

    function _testReturnDataSize(uint256 size) public pure {
        Scope memory scope = getInitialScope();
        scope.returndata = new bytes(size);

        assertStackDepth(scope, 0);
        InstructionsLib.opReturnDataSize(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, bytes32(size));
    }

    function _testReturnDataCopy(
        bytes memory returndata,
        uint256 dst,
        uint256 offset,
        uint256 length
    ) public pure {
        Scope memory scope = getInitialScope();
        scope.returndata = returndata;

        bytes32 _dst = bytes32(dst);
        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(length);

        assertStackDepth(scope, 0);
        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);

        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);

        scope.stack.push(_dst);
        assertStackDepth(scope, 3);
        assertStackPeek(scope, 0, _dst);
        assertStackPeek(scope, 1, _offset);
        assertStackPeek(scope, 2, _length);

        InstructionsLib.opReturnDataCopy(scope);
        assertStackDepth(scope, 0);

        bytes memory copy = scope._memory.extract(dst, length);
        uint256 len = offset + length <= returndata.length
            ? length
            : returndata.length - offset;
        bytes memory expected = new bytes(len);

        for (uint256 i; i < len; i++) {
            expected[i] = returndata[offset + i];
        }

        require(
            keccak256(copy) == keccak256(expected),
            "Invalid returndata copy"
        );
    }

    function _testExtCodeHash(address addr, bytes memory bytecode) public {
        Scope memory scope = getInitialScope();

        delete accounts[addr];
        createAccount(addr, 0);
        scope.api.setAccountBytecode(addr, bytecode);

        bytes32 _addr = bytes32(uint256(uint160(addr)));

        assertStackDepth(scope, 0);
        scope.stack.push(_addr);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _addr);

        InstructionsLib.opExtCodeHash(scope);
        assertStackDepth(scope, 1);

        assertStackPeek(scope, 0, keccak256(bytecode));
    }

    function _testSelfBalance(address addr, uint256 balance) public {
        Scope memory scope = getInitialScope();

        delete accounts[addr];
        createAccount(addr, balance);
        scope._contract.self = addr;

        assertStackDepth(scope, 0);
        InstructionsLib.opSelfBalance(scope);

        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(balance));
    }

    function _testPop() public pure {
        Scope memory scope = getInitialScope();

        assertStackDepth(scope, 0);
        scope.stack.push(bytes32(0));
        assertStackDepth(scope, 1);
        InstructionsLib.opPop(scope);
        assertStackDepth(scope, 0);
    }

    function _testMload(uint256 offset, uint256 value) public pure {
        Scope memory scope = getInitialScope();

        scope._memory.store(offset, bytes32(value));

        assertStackDepth(scope, 0);
        scope.stack.push(bytes32(offset));
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(offset));
        InstructionsLib.opMload(scope);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(value));
    }

    function _testMstore(uint256 offset, uint256 value) public pure {
        Scope memory scope = getInitialScope();

        bytes32 _offset = bytes32(offset);
        bytes32 _value = bytes32(value);

        assertStackDepth(scope, 0);
        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);
        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _value);
        InstructionsLib.opMstore(scope);
        assertStackDepth(scope, 0);

        bytes32 stored = scope._memory.load(offset);

        require(stored == bytes32(value), "Invalid mstore");
    }

    function _testMstore8(uint256 offset, uint8 value) public pure {
        Scope memory scope = getInitialScope();

        bytes32 _offset = bytes32(offset);
        bytes32 _value = bytes32(uint256(value));

        scope._memory.store8(offset, ~value);
        scope._memory.mem[offset + 1] = 0xFF;

        assertStackDepth(scope, 0);
        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);
        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _value);
        InstructionsLib.opMstore8(scope);
        assertStackDepth(scope, 0);

        bytes32 stored = scope._memory.load(offset);

        require(stored >> 248 == bytes32(uint256(value)), "Invalid mstore8");
        require(
            scope._memory.mem[offset + 1] == 0xFF,
            "mstore8 wrote more than 1 byte"
        );
    }

    function _testSload(uint256 key, uint256 value) public {
        Scope memory scope = getInitialScope();

        scope.api.writeAccountStorageAt(
            scope._contract.self,
            bytes32(key),
            bytes32(value)
        );

        bytes32 _key = bytes32(key);

        assertStackDepth(scope, 0);
        scope.stack.push(_key);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _key);
        InstructionsLib.opSload(scope);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(value));

        scope.api.writeAccountStorageAt(scope._contract.self, bytes32(key), 0);
    }

    function _testSstore(uint256 key, uint256 value, bool readOnly) public {
        Scope memory scope = getInitialScope();

        scope.readOnly = readOnly;

        bytes32 _key = bytes32(key);
        bytes32 _value = bytes32(value);

        // Ensure that we start on a clean storage slot
        scope.api.writeAccountStorageAt(scope._contract.self, bytes32(key), 0);

        assertStackDepth(scope, 0);
        scope.stack.push(_value);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _value);
        scope.stack.push(_key);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _key);
        assertStackPeek(scope, 1, _value);
        InstructionsLib.opSstore(scope);

        if (readOnly) {
            require(
                scope.stop == true,
                "Invalid sstore stop flag when readOnly"
            );
            require(
                scope.reverted == true,
                "Invalid sstore revert flag when readOnly"
            );

            bytes32 received = keccak256(scope.returndata);
            bytes32 expected = keccak256(
                abi.encodeWithSignature("Error(string)", READ_ONLY_ERROR)
            );

            require(
                received == expected,
                "Invalid sstore revert data when readOnly"
            );

            return;
        }

        assertStackDepth(scope, 0);

        bytes32 stored = scope.api.readAccountStorageAt(
            scope._contract.self,
            bytes32(key)
        );

        require(stored == bytes32(value), "Invalid sstore");

        // cleanup storage
        scope.api.writeAccountStorageAt(scope._contract.self, bytes32(key), 0);
    }

    function _testJump(uint256 offset) public pure {
        Scope memory scope = getInitialScope();

        bytes32 _offset = bytes32(offset);

        assertStackDepth(scope, 0);
        scope.stack.push(_offset);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _offset);
        InstructionsLib.opJump(scope);
        assertStackDepth(scope, 0);
        require(scope.pc == offset - 1, "Invalid jump");
    }

    function _testJumpi(uint256 offset, bool condition) public pure {
        Scope memory scope = getInitialScope();

        bytes32 _offset = bytes32(offset);
        bytes32 _condition = bytes32(uint256(condition ? 1 : 0));

        assertStackDepth(scope, 0);
        scope.stack.push(_condition);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _condition);
        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _condition);
        InstructionsLib.opJumpi(scope);
        assertStackDepth(scope, 0);
        require(scope.pc == (condition ? offset - 1 : 0), "Invalid jumpi");
    }

    function _testPc(uint256 pc) public pure {
        Scope memory scope = getInitialScope();
        scope.pc = pc;

        assertStackDepth(scope, 0);
        InstructionsLib.opPc(scope);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(pc));
    }

    function _testMsize(uint256 msize) public pure {
        Scope memory scope = getInitialScope();
        scope._memory.max = msize;

        assertStackDepth(scope, 0);
        InstructionsLib.opMsize(scope);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, bytes32(msize));
    }

    function _testJumpDest() public pure {
        Scope memory scope = getInitialScope();

        assertStackDepth(scope, 0);
        InstructionsLib.opJumpDest(scope);
        assertStackDepth(scope, 0);
    }

    function _testPushN() public pure {
        Scope memory scope = getInitialScope();

        bytes32 value = 0x1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef;

        scope
            ._contract
            .bytecode = hex"001234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";

        for (uint8 i = 0; i < 32; i++) {
            scope._contract.bytecode[0] = bytes1(PUSH1 + i);
            scope.pc = 0;
            assertStackDepth(scope, 0);
            InstructionsLib.opPushN(scope);
            assertStackDepth(scope, 1);

            // Compute extected value
            bytes32 expected = value >> (8 * (31 - i));

            assertStackPeek(scope, 0, expected);

            // Clear stack for next iteration
            scope.stack.pop();
        }
    }

    function _testDupN() public pure {
        Scope memory scope = getInitialScope();

        scope._contract.bytecode = new bytes(1);
        scope._contract.bytecode[0] = bytes1(DUP1);

        // Populate the stack
        for (uint256 i = 16; i > 0; i--) {
            scope.stack.push(bytes32(i));
        }

        assertStackDepth(scope, 16);

        for (uint8 i = 0; i < 16; i++) {
            scope._contract.bytecode[0] = bytes1(DUP1 + i);
            InstructionsLib.opDupN(scope);
            assertStackDepth(scope, 17);
            assertStackPeek(scope, 0, bytes32(uint256(i + 1)));
            scope.stack.pop();
        }
    }

    function _testSwapN() public pure {
        Scope memory scope = getInitialScope();

        scope._contract.bytecode = new bytes(1);
        scope._contract.bytecode[0] = bytes1(SWAP1);

        // Populate the stack
        for (uint256 i = 17; i > 0; i--) {
            scope.stack.push(bytes32(i));
        }

        assertStackDepth(scope, 17);

        for (uint8 i = 0; i < 16; i++) {
            scope._contract.bytecode[0] = bytes1(SWAP1 + i);
            InstructionsLib.opSwapN(scope);
            assertStackDepth(scope, 17);
            assertStackPeek(scope, 0, bytes32(uint256(i + 2)));
            assertStackPeek(scope, i + 1, bytes32(uint256(1)));
            scope.stack.swap(i + 1);
        }
    }

    function _testReturn(bytes memory data, uint256 offset) public pure {
        Scope memory scope = getInitialScope();

        uint256 src;

        assembly {
            src := add(data, 0x20)
        }

        scope._memory.inject(src, offset, data.length);

        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(data.length);

        assertStackDepth(scope, 0);
        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);
        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);
        InstructionsLib.opReturn(scope);
        assertStackDepth(scope, 0);

        require(scope.stop == true, "Invalid return stop flag");
        require(scope.reverted == false, "Invalid return revert flag");
        require(
            keccak256(scope.returndata) == keccak256(data),
            "Invalid return data"
        );
    }

    function _testRevert(bytes memory data, uint256 offset) public pure {
        Scope memory scope = getInitialScope();

        uint256 src;

        assembly {
            src := add(data, 0x20)
        }

        scope._memory.inject(src, offset, data.length);

        bytes32 _offset = bytes32(offset);
        bytes32 _length = bytes32(data.length);

        assertStackDepth(scope, 0);
        scope.stack.push(_length);
        assertStackDepth(scope, 1);
        assertStackPeek(scope, 0, _length);
        scope.stack.push(_offset);
        assertStackDepth(scope, 2);
        assertStackPeek(scope, 0, _offset);
        assertStackPeek(scope, 1, _length);
        InstructionsLib.opRevert(scope);
        assertStackDepth(scope, 0);

        require(scope.stop == true, "Invalid return stop flag");
        require(scope.reverted == true, "Invalid revert reverted flag");
        require(
            keccak256(scope.returndata) == keccak256(data),
            "Invalid revert data"
        );
    }
}
