// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./libraries/Account.sol";
import "./libraries/Stack.sol";
import "./libraries/Memory.sol";
import "./libraries/Context.sol";
import "./libraries/Opcodes.sol";
import "./libraries/Instructions.sol";
import "./State.sol";

abstract contract Core is State {
    using StackLib for Stack;
    using MemoryLib for Memory;

    // Input data structure when receiving a transaction
    struct Input {
        address caller;
        address to;
        uint256 value;
        bytes data;
    }

    /**
     * @dev Execute a transaction on the sEVM
     * @notice DO NOT MODIFY THIS FUNCTION
     * @param input The input of the transaction
     * @return rvalue The return data of the transaction
     */
    function execute(
        Input calldata input
    ) external returns (bytes memory rvalue) {
        bool deployment = false;
        address self = input.to;

        // Check if the sender account exists
        if (accounts[input.caller].self == address(0)) {
            revert("sEVM: Sender account does not exist");
        }

        // Check if this is a deployment
        if (input.to == address(0)) {
            // Create the contract account with the appropriate nonce
            self = getNextDeploymentAddress(input.caller);
            createAccount(self, 0);
            incrementAccountNonce(self);
            deployment = true;
        }

        // Increment the nonce of the sender account
        if (tx.origin == msg.sender) {
            incrementAccountNonce(input.caller);
        }

        // Transfer the value to the recipient
        if (input.value > 0) {
            transfer(input.caller, self, input.value);
        }

        // Create the virtual contract
        // If this is a deployment, the bytecode is the input data
        // Otherwise, the bytecode is the account bytecode
        Contract memory _contract = Contract({
            self: self,
            bytecode: deployment ? input.data : getAccountBytecode(self)
        });

        // Create the execution context
        Context memory context = Context({
            origin: input.caller,
            caller: input.caller,
            to: input.to,
            callvalue: input.value,
            _calldata: input.data
        });

        // Execute the transaction
        (bool reverted, bytes memory returndata) = _execute(
            context,
            _contract,
            false
        );

        if (reverted == false) {
            // Deployment return values are the contract bytecode
            if (deployment) {
                setAccountBytecode(self, returndata);
            }
        } else {
            assembly {
                revert(add(returndata, 0x20), mload(returndata))
            }
        }

        return returndata;
    }

    /**
     * @dev Execute a contract in a given context
     * @notice DO NOT MODIFY THIS FUNCTION
     * @param context The context of the execution
     * @param _contract The contract to execute
     * @param readOnly Whether the execution is read only or not
     * @return reverted Whether the execution reverted or not
     * @return returndata The returndata of the execution
     */
    function _execute(
        Context memory context,
        Contract memory _contract,
        bool readOnly
    ) internal returns (bool, bytes memory) {
        function(Scope memory) internal[256]
            memory instructions = getInstructions();

        // Create the execution scope consumed by the instructions
        Scope memory scope = Scope({
            _contract: _contract,
            stack: StackLib.init(4096),
            _memory: Memory({max: 0, mem: new bytes(8192)}),
            context: context,
            pc: 0,
            stop: false,
            reverted: false,
            returndata: new bytes(0),
            readOnly: readOnly,
            api: API({
                getAccount: getAccount,
                getAccountBalance: getAccountBalance,
                getAccountNonce: getAccountNonce,
                getAccountBytecode: getAccountBytecode,
                setAccountBytecode: setAccountBytecode,
                readAccountStorageAt: readAccountStorageAt,
                writeAccountStorageAt: writeAccountStorageAt,
                transfer: transfer
            })
        });

        // Execute the contract until it stops or reverts
        while (scope.stop == false && scope.pc < _contract.bytecode.length) {
            uint8 opcode = uint8(_contract.bytecode[scope.pc]);

            assembly {
                let uknown := iszero(
                    mload(add(instructions, add(0x20, mul(opcode, 0x20))))
                )
                if uknown {
                    opcode := INVALID
                }
            }

            instructions[opcode](scope);

            unchecked {
                scope.pc = scope.pc + 1;
            }
        }

        return (scope.reverted, scope.returndata);
    }

    /**
     * @dev Get the instructions table
     * @notice DO NOT MODIFY THIS FUNCTION
     */
    function getInstructions()
        internal
        pure
        returns (function(Scope memory) internal[256] memory)
    {
        function(Scope memory) internal[256] memory instructions;

        instructions[STOP] = InstructionsLib.opStop;
        instructions[ADD] = InstructionsLib.opAdd;
        instructions[SUB] = InstructionsLib.opSub;
        instructions[MUL] = InstructionsLib.opMul;
        instructions[DIV] = InstructionsLib.opDiv;
        instructions[SDIV] = InstructionsLib.opSDiv;
        instructions[MOD] = InstructionsLib.opMod;
        instructions[SMOD] = InstructionsLib.opSMod;
        instructions[ADDMOD] = InstructionsLib.opAddMod;
        instructions[MULMOD] = InstructionsLib.opMulMod;
        instructions[EXP] = InstructionsLib.opExp;
        instructions[SIGNEXTEND] = InstructionsLib.opSignExtend;
        instructions[LT] = InstructionsLib.opLt;
        instructions[GT] = InstructionsLib.opGt;
        instructions[SLT] = InstructionsLib.opSlt;
        instructions[SGT] = InstructionsLib.opSgt;
        instructions[EQ] = InstructionsLib.opEq;
        instructions[ISZERO] = InstructionsLib.opIsZero;
        instructions[AND] = InstructionsLib.opAnd;
        instructions[OR] = InstructionsLib.opOr;
        instructions[XOR] = InstructionsLib.opXor;
        instructions[NOT] = InstructionsLib.opNot;
        instructions[BYTE] = InstructionsLib.opByte;
        instructions[SHL] = InstructionsLib.opShl;
        instructions[SHR] = InstructionsLib.opShr;
        instructions[SAR] = InstructionsLib.opSar;
        instructions[SHA3] = InstructionsLib.opSha3;
        instructions[ADDRESS] = InstructionsLib.opAddress;
        instructions[BALANCE] = InstructionsLib.opBalance;
        instructions[ORIGIN] = InstructionsLib.opOrigin;
        instructions[CALLER] = InstructionsLib.opCaller;
        instructions[CALLVALUE] = InstructionsLib.opCallValue;
        instructions[CALLDATALOAD] = InstructionsLib.opCallDataLoad;
        instructions[CALLDATASIZE] = InstructionsLib.opCallDataSize;
        instructions[CALLDATACOPY] = InstructionsLib.opCallDataCopy;
        instructions[CODESIZE] = InstructionsLib.opCodeSize;
        instructions[CODECOPY] = InstructionsLib.opCodeCopy;
        instructions[GASPRICE] = InstructionsLib.opGasPrice;
        instructions[EXTCODESIZE] = InstructionsLib.opExtCodeSize;
        instructions[EXTCODECOPY] = InstructionsLib.opExtCodeCopy;
        instructions[RETURNDATASIZE] = InstructionsLib.opReturnDataSize;
        instructions[RETURNDATACOPY] = InstructionsLib.opReturnDataCopy;
        instructions[EXTCODEHASH] = InstructionsLib.opExtCodeHash;
        instructions[BLOCKHASH] = InstructionsLib.opBlockHash;
        instructions[COINBASE] = InstructionsLib.opCoinBase;
        instructions[TIMESTAMP] = InstructionsLib.opTimeStamp;
        instructions[NUMBER] = InstructionsLib.opNumber;
        instructions[PREVRANDAO] = InstructionsLib.opPrevRandao;
        instructions[GASLIMIT] = InstructionsLib.opGasLimit;
        instructions[POP] = InstructionsLib.opPop;
        instructions[MLOAD] = InstructionsLib.opMload;
        instructions[MSTORE] = InstructionsLib.opMstore;
        instructions[MSTORE8] = InstructionsLib.opMstore8;
        instructions[SLOAD] = InstructionsLib.opSload;
        instructions[SSTORE] = InstructionsLib.opSstore;
        instructions[JUMP] = InstructionsLib.opJump;
        instructions[JUMPI] = InstructionsLib.opJumpi;
        instructions[PC] = InstructionsLib.opPc;
        instructions[MSIZE] = InstructionsLib.opMsize;
        instructions[GAS] = InstructionsLib.opGas;
        instructions[JUMPDEST] = InstructionsLib.opJumpDest;
        instructions[PUSH1] = InstructionsLib.opPushN;
        instructions[PUSH2] = InstructionsLib.opPushN;
        instructions[PUSH3] = InstructionsLib.opPushN;
        instructions[PUSH4] = InstructionsLib.opPushN;
        instructions[PUSH5] = InstructionsLib.opPushN;
        instructions[PUSH6] = InstructionsLib.opPushN;
        instructions[PUSH7] = InstructionsLib.opPushN;
        instructions[PUSH8] = InstructionsLib.opPushN;
        instructions[PUSH9] = InstructionsLib.opPushN;
        instructions[PUSH10] = InstructionsLib.opPushN;
        instructions[PUSH11] = InstructionsLib.opPushN;
        instructions[PUSH12] = InstructionsLib.opPushN;
        instructions[PUSH13] = InstructionsLib.opPushN;
        instructions[PUSH14] = InstructionsLib.opPushN;
        instructions[PUSH15] = InstructionsLib.opPushN;
        instructions[PUSH16] = InstructionsLib.opPushN;
        instructions[PUSH17] = InstructionsLib.opPushN;
        instructions[PUSH18] = InstructionsLib.opPushN;
        instructions[PUSH19] = InstructionsLib.opPushN;
        instructions[PUSH20] = InstructionsLib.opPushN;
        instructions[PUSH21] = InstructionsLib.opPushN;
        instructions[PUSH22] = InstructionsLib.opPushN;
        instructions[PUSH23] = InstructionsLib.opPushN;
        instructions[PUSH24] = InstructionsLib.opPushN;
        instructions[PUSH25] = InstructionsLib.opPushN;
        instructions[PUSH26] = InstructionsLib.opPushN;
        instructions[PUSH27] = InstructionsLib.opPushN;
        instructions[PUSH28] = InstructionsLib.opPushN;
        instructions[PUSH29] = InstructionsLib.opPushN;
        instructions[PUSH30] = InstructionsLib.opPushN;
        instructions[PUSH31] = InstructionsLib.opPushN;
        instructions[PUSH32] = InstructionsLib.opPushN;
        instructions[DUP1] = InstructionsLib.opDupN;
        instructions[DUP2] = InstructionsLib.opDupN;
        instructions[DUP3] = InstructionsLib.opDupN;
        instructions[DUP4] = InstructionsLib.opDupN;
        instructions[DUP5] = InstructionsLib.opDupN;
        instructions[DUP6] = InstructionsLib.opDupN;
        instructions[DUP7] = InstructionsLib.opDupN;
        instructions[DUP8] = InstructionsLib.opDupN;
        instructions[DUP9] = InstructionsLib.opDupN;
        instructions[DUP10] = InstructionsLib.opDupN;
        instructions[DUP11] = InstructionsLib.opDupN;
        instructions[DUP12] = InstructionsLib.opDupN;
        instructions[DUP13] = InstructionsLib.opDupN;
        instructions[DUP14] = InstructionsLib.opDupN;
        instructions[DUP15] = InstructionsLib.opDupN;
        instructions[DUP16] = InstructionsLib.opDupN;
        instructions[SWAP1] = InstructionsLib.opSwapN;
        instructions[SWAP2] = InstructionsLib.opSwapN;
        instructions[SWAP3] = InstructionsLib.opSwapN;
        instructions[SWAP4] = InstructionsLib.opSwapN;
        instructions[SWAP5] = InstructionsLib.opSwapN;
        instructions[SWAP6] = InstructionsLib.opSwapN;
        instructions[SWAP7] = InstructionsLib.opSwapN;
        instructions[SWAP8] = InstructionsLib.opSwapN;
        instructions[SWAP9] = InstructionsLib.opSwapN;
        instructions[SWAP10] = InstructionsLib.opSwapN;
        instructions[SWAP11] = InstructionsLib.opSwapN;
        instructions[SWAP12] = InstructionsLib.opSwapN;
        instructions[SWAP13] = InstructionsLib.opSwapN;
        instructions[SWAP14] = InstructionsLib.opSwapN;
        instructions[SWAP15] = InstructionsLib.opSwapN;
        instructions[SWAP16] = InstructionsLib.opSwapN;
        instructions[LOG0] = InstructionsLib.opInvalid;
        instructions[LOG1] = InstructionsLib.opInvalid;
        instructions[LOG2] = InstructionsLib.opInvalid;
        instructions[LOG3] = InstructionsLib.opInvalid;
        instructions[LOG4] = InstructionsLib.opInvalid;
        instructions[CREATE] = InstructionsLib.opCreate;
        instructions[CALL] = InstructionsLib.opCall;
        instructions[CALLCODE] = InstructionsLib.opCallCode;
        instructions[RETURN] = InstructionsLib.opReturn;
        instructions[DELEGATECALL] = InstructionsLib.opDelegateCall;
        instructions[CREATE2] = InstructionsLib.opCreate2;
        instructions[STATICCALL] = InstructionsLib.opStaticCall;
        instructions[REVERT] = InstructionsLib.opRevert;
        instructions[INVALID] = InstructionsLib.opInvalid;
        instructions[SELFDESTRUCT] = InstructionsLib.opInvalid;

        return instructions;
    }
}
