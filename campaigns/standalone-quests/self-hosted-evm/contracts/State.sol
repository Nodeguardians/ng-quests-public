// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./libraries/Account.sol";
import "./libraries/Errors.sol";

contract State {

    // The accounts of the state.
    mapping(address => Account) public accounts;

    // The storage of the state.
    // All accounts storages are shared in a single mapping in the sEVM state.
    mapping(address => mapping(bytes32 => bytes32)) public storages;

    /**
     * @dev Returns the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to query the account of.
     * @return account The account associated with the given address.
     */
    function getAccount(address addr) internal view returns (Account memory) {
        return accounts[addr];
    }

    /**
     * @dev Returns the balance of the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to query the balance of.
     * @return balance The balance of the account associated with the given address.
     */
    function getAccountBalance(address addr) public view returns (uint256) {
        return accounts[addr].balance;
    }

    /**
     * @dev Returns the nonce of the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to query the nonce of.
     * @return nonce The nonce of the account associated with the given address.
     */
    function getAccountNonce(address addr) public view returns (uint256) {
        return accounts[addr].nonce;
    }

    /**
     * @dev Increments the nonce of the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to increment the nonce of.
     * @return nonce The new nonce of the account associated with the given address.
     */
    function incrementAccountNonce(address addr) public returns (uint256) {
        uint256 nonce = accounts[addr].nonce + 1;

        accounts[addr].nonce = nonce;
        return nonce;
    }

    /**
     * @dev Returns the bytecode of the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to query the bytecode of.
     * @return bytecode The bytecode of the account associated with the given address.
     */
    function getAccountBytecode(
        address addr
    ) public view returns (bytes memory) {
        return accounts[addr].bytecode;
    }

    /**
     * @dev Sets the bytecode of the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to set the bytecode of.
     * @param bytecode The bytecode to set.
     */
    function setAccountBytecode(address addr, bytes memory bytecode) public {
        accounts[addr].bytecode = bytecode;
    }

    /**
     * @dev Returns the value stored at the given key in the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to query the storage of.
     * @param key The key to query the storage at.
     * @return value The value stored at the given key in the account associated with the given address.
     */
    function readAccountStorageAt(
        address addr,
        bytes32 key
    ) public view returns (bytes32 value) {
        return storages[addr][key];
    }

    /**
     * @dev Sets the value stored at the given key in the account associated with the given address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param addr The address to set the storage of.
     * @param key The key to set the storage at.
     * @param value The value to set.
     */
    function writeAccountStorageAt(
        address addr,
        bytes32 key,
        bytes32 value
    ) internal {
        storages[addr][key] = value;
    }

    /**
     * @dev Validates that the account associated with the given address has sufficient funds to transfer the given value.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @param from The address to validate the balance of.
     * @param value The value to validate the balance against.
     * @return valid Whether the account associated with the given address has sufficient funds to transfer the given value.
     */
    function canTransfer(
        address from,
        uint256 value
    ) public view returns (bool) {
        return accounts[from].balance >= value;
    }

    /**
     * @dev Transfers the given value from the account associated with the given from address to the account associated with the given to address.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @dev Reverts if the account associated with the given from address does not have sufficient funds to transfer the given value.
     * @param from The address to transfer the value from.
     * @param to The address to transfer the value to.
     * @param value The value to transfer.
     */
    function transfer(address from, address to, uint256 value) public {
        if (accounts[from].balance < value) {
            revert(INSUFFICIENT_BALANCE_ERROR);
        }

        accounts[from].balance -= value;
        accounts[to].balance += value;
    }

    /**
     * @dev Creates an account associated with the given address with the given value.
     * @notice DO NOT MDOIFY THIS FUNCTION.
     * @dev Reverts if an account already exists at the given address.
     * @param addr The address to create the account at.
     * @param value The value to set the account balance to.
     */
    function createAccount(address addr, uint256 value) public {
        if (accounts[addr].self != address(0)) {
            revert(DUPLICATE_ACCOUNT_ERROR);
        }

        accounts[addr] = Account({
            self: addr,
            nonce: 0,
            balance: value,
            bytecode: new bytes(0)
        });
    }

    /**
     * @dev Compute the next address of a contract to be deployed by the sender.
     * @notice DO NOT MODIFY THIS FUNCTION
     * @param sender The address of the account deploying the contract.
     * @return address The next address of a contract to be deployed by the sender.
     */
    function getNextDeploymentAddress(
        address sender
    ) public view returns (address) {
        uint256 _nonce = accounts[sender].nonce;
        if (_nonce == 0x00)
            return
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xd6),
                                    bytes1(0x94),
                                    sender,
                                    uint8(0x80)
                                )
                            )
                        )
                    )
                );
        if (_nonce <= 0x7f)
            return
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xd6),
                                    bytes1(0x94),
                                    sender,
                                    uint8(_nonce)
                                )
                            )
                        )
                    )
                );
        if (_nonce <= 0xff)
            return
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xd7),
                                    bytes1(0x94),
                                    sender,
                                    bytes1(0x81),
                                    uint8(_nonce)
                                )
                            )
                        )
                    )
                );
        if (_nonce <= 0xffff)
            return
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xd8),
                                    bytes1(0x94),
                                    sender,
                                    bytes1(0x82),
                                    uint16(_nonce)
                                )
                            )
                        )
                    )
                );
        if (_nonce <= 0xffffff)
            return
                address(
                    uint160(
                        uint256(
                            keccak256(
                                abi.encodePacked(
                                    bytes1(0xd9),
                                    bytes1(0x94),
                                    sender,
                                    bytes1(0x83),
                                    uint24(_nonce)
                                )
                            )
                        )
                    )
                );
        return
            address(
                uint160(
                    uint256(
                        keccak256(
                            abi.encodePacked(
                                bytes1(0xda),
                                bytes1(0x94),
                                sender,
                                bytes1(0x84),
                                uint32(_nonce)
                            )
                        )
                    )
                )
            ); // more than 2^32 nonces not realistic
    }
}
