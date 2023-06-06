// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "./Core.sol";
import "./interfaces/ICrossTx.sol";

contract sEVM is Core, ICrossTx {

    /**
     * @dev Executes a call to the given address with the given input data.
     * @param input The input to the call.
     * @param readOnly Whether the call is read-only.
     * @return The return data from the call.
     */
    function call(
        ICrossTx.InternalInput calldata input,
        bool readOnly
    ) external returns (bytes memory) {
        // CODE HERE
    }

    /**
     * @dev Executes a delegate call to the given address with the given data.
     * @notice the storage context of the delegator should be used.
     * @param input The input data for the call.
     * @param readOnly Whether the call is read-only.
     * @return output The output data from the call.
     */
    function delegateCall(
        ICrossTx.InternalInput calldata input,
        bool readOnly
    ) external returns (bytes memory) {
        // CODE HERE
    }

    /**
     * @dev Executes a static call to the given address with the given data.
     * @param input The input data for the call.
     * @return output The output data from the call.
     */
    function staticCall(
        ICrossTx.InternalInput calldata input
    ) external returns (bytes memory) {
        // CODE HERE
    }

    /**
     * @dev Create a contract using CREATE
     * @param input The input data
     * @param readOnly Whether the call is read only
     * @return newAddress The address of the created contract
     */
    function create(
        ICrossTx.InternalInput calldata input,
        bool readOnly
    ) external returns (address) {
        // CODE HERE
    }

    /**
     * @dev Create a contract using CREATE2
     * @param input The input data
     * @param readOnly Whether the call is read only
     * @param salt The salt to use upon creation
     * @return newAddress The address of the created contract
     */
    function create2(
        ICrossTx.InternalInput calldata input,
        bool readOnly,
        uint256 salt
    ) external returns (address) {
        // CODE HERE
    }
}
