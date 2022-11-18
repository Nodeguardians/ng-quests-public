// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IGrandmasters {

    /// @notice Returns true if the given address is a grandmaster, and false otherwise
    /// @param user Address to check
    function grandmasters(address user) external returns (bool);

    /// @notice Promotes msg.sender to grandmaster. Reverts if signature is invalid.
    /// @param signature Signature of message "Invite{msg.sender}" from a grandmaster
    function acceptInvite(bytes calldata signature) external;

    /// @notice Transfers some funds to the msg.sender. Reverts if signature is invalid.
    /// @param amount Amount of funds to transfer (in wei)
    /// @param signature Signature of message  "Bless{msg.sender}{amount}{ctr}" from a grandmaster
    function receiveBlessing(uint256 amount, bytes calldata signature) external;

}