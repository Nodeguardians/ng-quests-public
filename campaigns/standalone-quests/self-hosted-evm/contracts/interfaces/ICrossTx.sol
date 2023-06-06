// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface ICrossTx {

    // Input data structure when receiving an internal sEVM (call, delegatecall, etc.)
    struct InternalInput {
        address origin;
        address caller;
        address delegator;
        address to;
        uint256 value;
        bytes data;
    }

    /**
     * @dev Executes a call to the given address with the given input data.
     * @param input The input to the call.
     * @param readOnly Whether the call is read-only.
     * @return The return data from the call.
     */
    function call(
        InternalInput calldata input,
        bool readOnly
    ) external returns (bytes memory);

    /**
     * @dev Executes a delegate call to the given address with the given data.
     * @notice the storage context of the delegator should be used.
     * @param input The input data for the call.
     * @param readOnly Whether the call is read-only.
     * @return The output data from the call.
     */
    function delegateCall(
        InternalInput calldata input,
        bool readOnly
    ) external returns (bytes memory);

    /**
     * @dev Executes a static call to the given address with the given data.
     * @param input The input data for the call.
     * @return The output data from the call.
     */
    function staticCall(
        InternalInput calldata input
    ) external returns (bytes memory);

    /**
     * @dev Create a contract using CREATE2
     * @param input The input data
     * @param readOnly Whether the call is read only
     * @return The address of the created contract
     */
    function create(
        InternalInput calldata input,
        bool readOnly
    ) external returns (address);

    /**
     * @dev Create a contract using CREATE2
     * @param input The input data
     * @param readOnly Whether the call is read only
     * @param salt The salt to use upon creation
     * @return The address of the created contract
     */
    function create2(
        InternalInput calldata input,
        bool readOnly,
        uint256 salt
    ) external returns (address);

}