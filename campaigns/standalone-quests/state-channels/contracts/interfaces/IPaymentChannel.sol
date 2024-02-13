// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

interface IPaymentChannel {

    /// @notice Sender of funds.
    function owner() external returns (address payable);
    /// @notice Receiver of funds.
    function worker() external returns (address payable);

    /**
     * @notice Expiration time. 
     * After this time, the channel can no longer be closed by the worker, 
     * and the owner can call timeOut() to retrieve 
     * their funds and close the channel.
     */
    function expiration() external returns (uint256);

    /**
     * @notice Represents whether the channel is opened or closed.
     * An open channel is still in operation and can be interacted with,
     * whereas a closed channel is no longer usable and cannot have
     * its state modified.
     */
    function isActive() external returns (bool);

    /**
     * @notice Extends the time window for the worker to close the channel.
     * Can only be called by the owner.
     * @param _time Amount of time to add to the expiration time.
     */
    function addTime(uint256 _time) external;

    /**
     * @notice If the worker does not close the channel in time, 
     * transfer all funds to the owner and close the channel. 
     * Can only be called by the owner.
     */
    function timeOut() external;

    /**
     * If _signature is valid, the worker receives `_amount` of ETH 
     * and the owner gets the remainder back. The channel is then closed. 
     * Can only be called by the worker and before expiration. 
     * @param _amount Amount of ETH to be transferred to the worker.
     * @param _signature Signature of the message, signed by the owner.
     */
    function closeChannel(
        uint256 _amount, 
        bytes memory _signature
    ) external;

}
