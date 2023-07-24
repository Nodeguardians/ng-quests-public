// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Context.sol";
import "./Stack.sol";
import "./Memory.sol";
import "../Core.sol";
import "../interfaces/ICrossTx.sol";

// ============================================================================================
// ============================================================================================
// Implement the EVM instructions
// You can find information about the EVM instructions here: https://www.sEVM.codes/?fork=merge
//
// Every instruction is implemented as a function that takes a Scope struct as a parameter.
// Check the Scope struct definition in Context.sol
// ============================================================================================
// ============================================================================================

library InstructionsLib {
    using StackLib for Stack;
    using MemoryLib for Memory;

    // ======================
    //   BASIC INSTRUCTIONS
    // ======================

    /**
     * @dev STOP instruction.
     * @notice Halts execution by setting the STOP flag in the scope.
     * @param scope The current execution scope.
     */
    function opStop(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev ADD instruction.
     * @notice Pops the top two values from the stack, adds them and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs + rhs, ...]
     * @param scope The current execution scope.
     */
    function opAdd(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SUB instruction.
     * @notice Pops the top two values from the stack, subtracts them and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs - rhs, ...]
     * @param scope The current execution scope.
     */
    function opSub(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MUL instruction.
     * @notice Pops the top two values from the stack, multiplies them and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs * rhs, ...]
     * @param scope The current execution scope.
     */
    function opMul(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev DIV instruction.
     * @notice Pops the top two values from the stack, divides them and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs / rhs, ...]
     * @param scope The current execution scope.
     */
    function opDiv(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SDIV instruction.
     * @notice Pops the top two (signed) values from the stack, divides them and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs / rhs, ...]
     * @param scope The current execution scope.
     */
    function opSDiv(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MOD instruction.
     * @notice Pops the top two values from the stack, calculates the modulus and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs % rhs, ...]
     * @param scope The current execution scope.
     */
    function opMod(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SMOD instruction.
     * @notice Pops the top two (signed) values from the stack, calculates the modulus and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs % rhs, ...]
     * @param scope The current execution scope.
     */
    function opSMod(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev ADDMOD instruction.
     * @notice Pops the top three values from the stack, adds the first two, calculates the modulus and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, mod, ...] => STACK = [(lhs + rhs) % mod, ...]
     * @param scope The current execution scope.
     */
    function opAddMod(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MULMOD instruction.
     * @notice Pops the top three values from the stack, multiplies the first two, calculates the modulus and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, mod, ...] => STACK = [(lhs * rhs) % mod, ...]
     * @param scope The current execution scope.
     */
    function opMulMod(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev EXP instruction.
     * @notice Pops the top two values from the stack, raises the first to the power of the second and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs ** rhs, ...]
     * @param scope The current execution scope.
     */
    function opExp(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SIGNEXTEND instruction.
     * @notice Pops the top two values from the stack, extends the sign of the first value to the length of the second value and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [signextend(lhs, rhs), ...]
     * @param scope The current execution scope.
     */
    function opSignExtend(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev LT instruction.
     * @notice Pops the top two values from the stack, compares them (<) and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs < rhs, ...]
     * @param scope The current execution scope.
     */
    function opLt(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev GT instruction.
     * @notice Pops the top two values from the stack, compares them (>) and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs > rhs, ...]
     * @param scope The current execution scope.
     */
    function opGt(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SLT instruction.
     * @notice Pops the top two (signed) values from the stack, compares them (<) and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs < rhs, ...]
     * @param scope The current execution scope.
     */
    function opSlt(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SGT instruction.
     * @notice Pops the top two (signed) values from the stack, compares them (>) and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs > rhs, ...]
     * @param scope The current execution scope.
     */
    function opSgt(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev EQ instruction.
     * @notice Pops the top two values from the stack, compares them (==) and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs == rhs, ...]
     * @param scope The current execution scope.
     */
    function opEq(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev ISZERO instruction.
     * @notice Pops the top value from the stack, compares it to zero (==) and pushes the result back to the stack.
     * @notice STACK = [value, ...] => STACK = [value == 0, ...]
     * @param scope The current execution scope.
     */
    function opIsZero(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev AND instruction.
     * @notice Pops the top two values from the stack, performs a bitwise AND and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs & rhs, ...]
     * @param scope The current execution scope.
     */
    function opAnd(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev OR instruction.
     * @notice Pops the top two values from the stack, performs a bitwise OR and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs | rhs, ...]
     * @param scope The current execution scope.
     */
    function opOr(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev XOR instruction.
     * @notice Pops the top two values from the stack, performs a bitwise XOR and pushes the result back to the stack.
     * @notice STACK = [lhs, rhs, ...] => STACK = [lhs ^ rhs, ...]
     * @param scope The current execution scope.
     */
    function opXor(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev NOT instruction.
     * @notice Pops the top value from the stack, performs a bitwise NOT and pushes the result back to the stack.
     * @notice STACK = [value, ...] => STACK = [~value, ...]
     * @param scope The current execution scope.
     */
    function opNot(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev BYTE instruction.
     * @notice Pops the top two values from the stack, get the byte at the specified index and pushes the result back to the stack.
     * @notice STACK = [index, value, ...] => STACK = [byte(index, value), ...]
     * @param scope The current execution scope.
     */
    function opByte(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SHL instruction.
     * @notice Pops the top two values from the stack, performs a bitwise left shift and pushes the result back to the stack.
     * @notice STACK = [shift, value, ...] => STACK = [value << shift, ...]
     * @param scope The current execution scope.
     */
    function opShl(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SHR instruction.
     * @notice Pops the top two values from the stack, performs a bitwise right shift and pushes the result back to the stack.
     * @notice STACK = [shift, value, ...] => STACK = [value >> shift, ...]
     * @param scope The current execution scope.
     */
    function opShr(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SAR instruction.
     * @notice Pops the top two values from the stack, performs a (signed) bitwise right shift and pushes the result back to the stack.
     * @notice STACK = [shift, value, ...] => STACK = [value >>> shift, ...]
     * @param scope The current execution scope.
     */
    function opSar(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SHA3 instruction.
     * @notice Pops the top two values from the stack, computes the SHA3 hash of the specified memory range and pushes the result back to the stack.
     * @notice STACK = [offset, length, ...] => STACK = [sha3(offset, length), ...]
     * @param scope The current execution scope.
     */
    function opSha3(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev ADDRESS instruction.
     * @notice Pushes the address of the current contract being executed to the stack.
     * @notice STACK = [...] => STACK = [address, ...]
     * @param scope The current execution scope.
     */
    function opAddress(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev BALANCE instruction.
     * @notice Pop the address of an account from the stack, push the balance of that account to the stack.
     * @notice STACK = [address, ...] => STACK = [address.balance, ...]
     * @param scope The current execution scope.
     */
    function opBalance(Scope memory scope) internal view {
        // CODE HERE
    }

    /**
     * @dev ORIGIN instruction.
     * @notice Pushes the address of the original transaction sender to the stack.
     * @notice STACK = [...] => STACK = [origin (tx.origin), ...]
     * @param scope The current execution scope.
     */
    function opOrigin(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CALLER instruction.
     * @notice Pushes the address of the caller to the stack.
     * @notice STACK = [...] => STACK = [caller (msg.sender), ...]
     * @param scope The current execution scope.
     */
    function opCaller(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CALLVALUE instruction.
     * @notice Pushes the value of the current call to the stack.
     * @notice STACK = [...] => STACK = [callvalue (msg.value), ...]
     * @param scope The current execution scope.
     */
    function opCallValue(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CALLDATALOAD instruction.
     * @notice Pops the top value from the stack, loads the specified 32-byte word from the calldata and pushes the result back to the stack.
     * @notice STACK = [offset, ...] => STACK = [calldata[offset], ...]
     * @param scope The current execution scope.
     */
    function opCallDataLoad(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CALLDATASIZE instruction.
     * @notice Pushes the size of the calldata to the stack.
     * @notice STACK = [...] => STACK = [calldatasize, ...]
     * @param scope The current execution scope.
     */
    function opCallDataSize(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CALLDATACOPY instruction.
     * @notice Pops the top three values from the stack, copies the specified range of calldata to memory and pushes the result back to the stack.
     * @notice STACK = [memOffset, dataOffset, length, ...] => STACK = [...]
     * @notice MEMORY[memOffset:memOffset+length] = CALLDATA[dataOffset:dataOffset+length
     * @param scope The current execution scope.
     */
    function opCallDataCopy(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CODESIZE instruction.
     * @notice Pushes the size of the code of the current contract being executed to the stack.
     * @notice STACK = [...] => STACK = [codesize, ...]
     * @param scope The current execution scope.
     */
    function opCodeSize(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev CODECOPY instruction.
     * @notice Pops the top three values from the stack, copies the specified range of code to memory and pushes the result back to the stack.
     * @notice STACK = [memOffset, codeOffset, length, ...] => STACK = [...]
     * @notice MEMORY[memOffset:memOffset+length] = CODE[codeOffset:codeOffset+length]
     * @param scope The current execution scope.
     */
    function opCodeCopy(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev GASPRICE instruction.
     * @notice Pushes the gas price of the current transaction to the stack.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opGasPrice(Scope memory scope) internal view {
        scope.stack.push(bytes32(tx.gasprice));
    }

    /**
     * @dev EXTCODESIZE instruction.
     * @notice Pops the top value from the stack, pushes the size of the code of the specified account to the stack.
     * @notice STACK = [address, ...] => STACK = [codesize, ...]
     * @param scope The current execution scope.
     */
    function opExtCodeSize(Scope memory scope) internal view {
        // CODE HERE
    }

    /**
     * @dev EXTCODECOPY instruction.
     * @notice Pops the top four values from the stack, copies the specified range of code of the specified account to memory and pushes the result back to the stack.
     * @ notice STACK = [address, memOffset, codeOffset, length, ...] => STACK = [...]
     * @notice MEMORY[memOffset:memOffset+length] = EXTCODE[address][codeOffset:codeOffset+length]
     * @param scope The current execution scope.
     */
    function opExtCodeCopy(Scope memory scope) internal view {
        // CODE HERE
    }

    /**
     * @dev RETURNDATASIZE instruction.
     * @notice Pushes the size of the return data of the current call to the stack.
     * @notice STACK = [...] => STACK = [returndatasize, ...]
     * @param scope The current execution scope.
     */
    function opReturnDataSize(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev RETURNDATACOPY instruction.
     * @notice Pops the top three values from the stack, copies the specified range of return data to memory and pushes the result back to the stack.
     * @notice STACK = [memOffset, dataOffset, length, ...] => STACK = [...]
     * @notice MEMORY[memOffset:memOffset+length] = RETURNDATA[dataOffset:dataOffset+length]
     * @param scope The current execution scope.
     */
    function opReturnDataCopy(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev EXTCODEHASH instruction.
     * @notice Pops the top value from the stack, pushes the hash of the code of the specified account to the stack.
     * @notice STACK = [address, ...] => STACK = [keccak256(address.bytecode), ...]
     * @param scope The current execution scope.
     */
    function opExtCodeHash(Scope memory scope) internal view {
        // CODE HERE
    }

    /**
     * @dev BLOCKHASH instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opBlockHash(Scope memory scope) internal view {
        scope.stack.push(blockhash(block.number));
    }

    /**
     * @dev COINBASE instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opCoinBase(Scope memory scope) internal view {
        scope.stack.push(bytes32(uint256(uint160(address(block.coinbase)))));
    }

    /**
     * @dev TIMESTAMP instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opTimeStamp(Scope memory scope) internal view {
        scope.stack.push(bytes32(block.timestamp));
    }

    /**
     * @dev NUMBER instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opNumber(Scope memory scope) internal view {
        scope.stack.push(bytes32(block.number));
    }

    /**
     * @dev DIFFICULTY instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opPrevRandao(Scope memory scope) internal view {
        scope.stack.push(bytes32(block.prevrandao));
    }

    /**
     * @dev GASLIMIT instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opGasLimit(Scope memory scope) internal view {
        scope.stack.push(bytes32(block.gaslimit));
    }

    /**
     * @dev CHAINID instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opChainId(Scope memory scope) internal view {
        scope.stack.push(bytes32(block.chainid));
    }

    /**
     * @dev SELFBALANCE instruction.
     * @notice pushes the balance of the current contract to the stack.
     * @notice STACK = [...] => STACK = [balance, ...]
     * @param scope The current execution scope.
     */
    function opSelfBalance(Scope memory scope) internal view {
        // CODE HERE
    }

    /**
     * @dev BASEFEE instruction.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opBaseFee(Scope memory scope) internal view {
        scope.stack.push(bytes32(block.basefee));
    }

    /**
     * @dev POP instruction.
     * @notice Pops the top value from the stack.
     * @notice STACK = [value, ...] => STACK = [...]
     * @param scope The current execution scope.
     */
    function opPop(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MLOAD instruction.
     * @notice Pops the top value from the stack, pushes the value at the specified memory offset to the stack.
     * @notice STACK = [offset, ...] => STACK = [MEMORY[offset:offset+32], ...]
     * @param scope The current execution scope.
     */
    function opMload(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MSTORE instruction.
     * @notice Pops the top two values from the stack, stores the second 32 bytes value at the specified memory offset.
     * @notice STACK = [offset, value, ...] => STACK = [...]
     * @notice MEMORY[offset:offset+32] = value
     * @param scope The current execution scope.
     */
    function opMstore(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MSTORE8 instruction.
     * @notice Pops the top two values from the stack, stores the second 1 byte value at the specified memory offset.
     * @notice STACK = [offset, value, ...] => STACK = [...]
     * @notice MEMORY[offset] = value
     * @param scope The current execution scope.
     */
    function opMstore8(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SLOAD instruction.
     * @notice Pops the top value from the stack, pushes the value at the specified storage key to the stack.
     * @notice STACK = [key, ...] => STACK = [STORAGE[key], ...]
     * @param scope The current execution scope.
     */
    function opSload(Scope memory scope) internal view {
        // CODE HERE
    }

    /**
     * @dev SSTORE instruction.
     * @notice Pops the top two values from the stack, stores the second value at the specified storage key.
     * @notice STACK = [key, value, ...] => STACK = [...]
     * @notice STORAGE[key] = value
     * @param scope The current execution scope.
     */
    function opSstore(Scope memory scope) internal {
        // CODE HERE
    }

    /**
     * @dev JUMP instruction.
     * @notice Pops the top value from the stack, sets the program counter to the specified value.
     * @notice The program counter will be incremented by one by the main loop...
     * @notice STACK = [dest, ...] => STACK = [...]
     * @param scope The current execution scope.
     */
    function opJump(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev JUMPI instruction.
     * @notice Pops the top two values from the stack, sets the program counter to the first value if the second value is not zero.
     * @notice The program counter will be incremented by one by the main loop...
     * @notice STACK = [dest, cond, ...] => STACK = [...]
     * @param scope The current execution scope.
     */
    function opJumpi(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev PC instruction.
     * @notice pushes the current program counter to the stack.
     * @notice STACK = [...] => STACK = [pc, ...]
     * @param scope The current execution scope.
     */
    function opPc(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev MSIZE instruction.
     * @notice pushes the current memory size to the stack (maximum memory offset accessed)
     * @notice STACK = [...] => STACK = [msize, ...]
     * @param scope The current execution scope.
     */
    function opMsize(Scope memory scope) internal pure {
        scope.stack.push(bytes32(scope._memory.max));
    }

    /**
     * @dev GAS instruction.
     * @notice pushes the current gas left to the stack.
     * @notice THIS INSTRUCTION IS ALREADY IMPLEMENTED
     * @param scope The current execution scope.
     */
    function opGas(Scope memory scope) internal view {
        scope.stack.push(bytes32(gasleft()));
    }

    /**
     * @dev JUMPDEST instruction.
     * @notice no-op : this instruction is only used to mark valid jump destinations.
     * @notice STACK = [...] => STACK = [...]
     */
    function opJumpDest(Scope memory scope) internal pure {
        // no-op
    }

    /**
     * @dev PUSHN instruction.
     * @notice pushes the next N bytes of code to the stack.
     * @notice Given that the N bytes of code are actually data to be pushed to the stack, the program counter should be incremented.
     * @notice STACK = [...] => STACK = [data, ...]
     * @param scope The current execution scope.
     */
    function opPushN(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev DUPN instruction.
     * @notice pushes (dupplicates) the Nth value from the top of the stack to the top of the stack.
     * @notice STACK = [..., value, ...] => STACK = [value, ..., value, ...]
     * @param scope The current execution scope.
     */
    function opDupN(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev SWAPN instruction.
     * @notice swaps the top value of the stack with the Nth value from the top of the stack.
     * @notice STACK = [value1, ..., value2, ...] => STACK = [value2, ..., value1, ...]
     * @param scope The current execution scope.
     */
    function opSwapN(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev RETURN instruction.
     * @notice return the given data.
     * @notice the data is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice STACK = [offset, size, ...] => STACK = []
     * @notice RETURNDATA = MEMORY[offset:offset+size]
     * @param scope The current execution scope.
     */
    function opReturn(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev REVERT instruction.
     * @notice revert the current execution.
     * @notice the data is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice STACK = [offset, size, ...] => STACK = [...]
     * @notice MEMORYY[offset:offset+size] = returndata
     * @param scope The current execution scope.
     */
    function opRevert(Scope memory scope) internal pure {
        // CODE HERE
    }

    /**
     * @dev INVALID instruction.
     * @notice stop & revert the execution and set the returndata to "invalid opcode".
     * @param scope The current execution scope.
     */
    function opInvalid(Scope memory scope) internal pure {
        // CODE HERE
    }

    // =======================
    //   CREATE INSTRUCTIONS
    // =======================

    /**
     * @dev CREATE instruction.
     * @notice creates a new contract with the given value and code.
     * @notice the code is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice the address of the new contract is pushed to the stack, or 0 if the creation failed.
     * @notice This instruction should be implemented using an external call to the sEVM.create() function.
     * @notice sEVM.create() may throw an exception, which should be caught and the context returndata set to the revert reason.
     * @notice STACK = [value, argOffset, argSize, ...] => STACK = [address, ...]
     * @param scope The current execution scope.
     */
    function opCreate(Scope memory scope) internal {
        /*
        ...
        try ICrossTx(address(this)).create(...) {
            ...
        } catch (bytes memory rdata) {
            ...
        }
        */
    }

    /**
     * @dev CREATE2 instruction.
     * @notice creates a new contract with the given value, code and salt.
     * @notice the code is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice the address of the new contract is pushed to the stack, or 0 if the creation failed.
     * @notice This instruction should be implemented using an external call to the sEVM.create2() function.
     * @notice sEVM.create2() may throw an exception, which should be caught and the context returndata set to the revert reason.
     * @notice STACK = [value, argOffset, argSize, salt, ...] => STACK = [address, ...]
     * @param scope The current execution scope.
     */
    function opCreate2(Scope memory scope) internal {
        /*
        ...
        try ICrossTx(address(this)).create2(...) {
            ...
        } catch (bytes memory rdata) {
            ...
        }
        */
    }

    // =====================
    //   CALL INSTRUCTIONS
    // =====================

    /**
     * @dev CALL instruction.
     * @notice calls the given address with the given value and data.
     * @notice the code is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice 1 is pushed to the stack if the call succeeded, 0 otherwise.
     * @notice This instruction should be implemented using an external call to the sEVM.call() function.
     * @notice sEVM.call() may throw an exception, which should be caught and the context returndata set to the revert reason.
     * @notice STACK = [gas, to, value, argOffset, argSize, retOffset, retSize, ...] => STACK = [success, ...]
     * @notice MEMORYY[retOffset:retOffset+retSize] = returndata
     * @param scope The current execution scope.
     */
    function opCall(Scope memory scope) internal {
        /*
        ...
        try ICrossTx(address(this)).call(...) {
            ...
        } catch (bytes memory _rdata) {
            ...
        }
        */
    }

    /**
     * @dev CALLCODE instruction.
     * @notice callcode behaves like delegatecall but doesn't preserve msg.sender.
     * @notice callcode the given address with the given value and data.
     * @notice the code is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice 1 is pushed to the stack if the call succeeded, 0 otherwise.
     * @notice This instruction should be implemented using an external call to the sEVM.delegateCall() function.
     * @notice sEVM.callCode() may throw an exception, which should be caught and the context returndata set to the revert reason.
     * @notice STACK = [gas, to, value, argOffset, argSize, retOffset, retSize, ...] => STACK = [success, ...]
     * @notice MEMORYY[retOffset:retOffset+retSize] = returndata
     * @param scope The current execution scope.
     */
    function opCallCode(Scope memory scope) internal {
        /*
        ...
        try ICrossTx(address(this)).delegateCall(...) {
            ...
        } catch (bytes memory _rdata) {
            ...
        }
        */
    }

    /**
     * @dev DELEGATECALL instruction.
     * @notice delegatecall the given address with the given data.
     * @notice the code is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice 1 is pushed to the stack if the call succeeded, 0 otherwise.
     * @notice This instruction should be implemented using an external call to the sEVM.delegateCall() function.
     * @notice sEVM.delegateCall() may throw an exception, which should be caught and the context returndata set to the revert reason.
     * @notice STACK = [gas, to, argOffset, argSize, retOffset, retSize, ...] => STACK = [success, ...]
     * @notice MEMORYY[retOffset:retOffset+retSize] = returndata
     * @param scope The current execution scope.
     */
    function opDelegateCall(Scope memory scope) internal {
        /*
        ...
        try ICrossTx(address(this)).delegateCall(...) {
            ...
        } catch (...) {
            ...
        }
        */
    }

    /**
     * @dev STATICCALL instruction.
     * @notice staticcall the given address with the given data.
     * @notice the code is taken from the memory, starting at the offset and with the size given as arguments on the stack.
     * @notice 1 is pushed to the stack if the call succeeded, 0 otherwise.
     * @notice This instruction should be implemented using an external call to the sEVM.staticCall() function.
     * @notice sEVM.staticCall() may throw an exception, which should be caught and the context returndata set to the revert reason.
     * @notice STACK = [gas, to, argOffset, argSize, retOffset, retSize, ...] => STACK = [success, ...]
     * @notice MEMORYY[retOffset:retOffset+retSize] = returndata
     * @param scope The current execution scope.
     */
    function opStaticCall(Scope memory scope) internal {
        /*
        ...
        try ICrossTx(address(this)).staticcall(...) {
            ...
        } catch (bytes memory _rdata) {
            ...
        }
        */
    }
}
