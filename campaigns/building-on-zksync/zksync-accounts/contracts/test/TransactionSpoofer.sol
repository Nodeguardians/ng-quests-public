// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IAccount.sol";

/// @notice Test contract that spoofs the Bootloader.
contract TransactionSpoofer {

    function spoofValidateTransaction(
        IAccount _target
    ) public {
        (Transaction memory transaction, bytes32 txHash) = _getTransactionDetails(_target);

        _target.validateTransaction(
            txHash,
            txHash,
            transaction
        );
    }

    function spoofPayForTransaction(
        IAccount _target
    ) public {
        (Transaction memory transaction, bytes32 txHash) = _getTransactionDetails(_target);

        _target.payForTransaction(
            txHash,
            txHash,
            transaction
        );
    }

    function spoofExecuteTransaction(
        IAccount _target
    ) public {
        (Transaction memory transaction, bytes32 txHash) = _getTransactionDetails(_target);

        _target.executeTransaction(
            txHash,
            txHash,
            transaction
        );
    }

    function _getTransactionDetails(
        IAccount _target
    ) private view returns (
        Transaction memory transaction, 
        bytes32 txHash
    ) {
        transaction = Transaction({
            txType: 113,
            from: uint256(uint160(address(_target))),
            to: uint256(uint160(address(this))),
            gasLimit: 100000,
            gasPerPubdataByteLimit: 50000,
            maxFeePerGas: tx.gasprice,
            maxPriorityFeePerGas: 0,
            paymaster: 0,
            nonce: 0,
            value: 0,
            reserved: [uint256(0), 0, 0, 0],
            data: "",
            signature: "",
            factoryDeps: new bytes32[](0),
            paymasterInput: "",
            reservedDynamic: ""
        });

        txHash = keccak256(abi.encode(transaction));
    }
}
