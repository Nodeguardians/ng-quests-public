// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@matterlabs/zksync-contracts/l2/system-contracts/interfaces/IPaymaster.sol";

contract TransactionSpoofer {

    function spoofValidateAndPayForPaymasterTransaction(
        IPaymaster _target
    ) public {
        _target.validateAndPayForPaymasterTransaction(
            keccak256(abi.encode(block.timestamp)),
            keccak256(abi.encode(block.timestamp)),
            _getTransactionDetails(_target)
        );
    }

    function spoofPostTransaction(
        IPaymaster _target
    ) public {
        _target.postTransaction(
            "",
            _getTransactionDetails(_target),
            keccak256(abi.encode(block.timestamp)),
            keccak256(abi.encode(block.timestamp)),
            ExecutionResult.Success,
            1000
        );
    }


    function _getTransactionDetails(IPaymaster _target) private returns (Transaction memory) {
        return Transaction({
            txType: 113,
            from: uint256(uint160(address(this))),
            to: uint256(uint160(address(this))),
            gasLimit: 100000,
            gasPerPubdataByteLimit: 50000,
            maxFeePerGas: tx.gasprice,
            maxPriorityFeePerGas: 0,
            paymaster: uint256(uint160(address(_target))),
            nonce: 0,
            value: 0,
            reserved: [uint256(0), 0, 0, 0],
            data: "",
            signature: "",
            factoryDeps: new bytes32[](0),
            paymasterInput: "",
            reservedDynamic: ""
        });
    }
}
