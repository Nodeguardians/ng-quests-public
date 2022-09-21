// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IGrimoires {

    /// @dev Emitted when a grimoire is stealthily transferred to `stealthRecipient`
    event StealthTransfer(address indexed stealthRecipient, bytes32 publishedDataX, bytes32 publishedDataY);

    /// @dev Mints a grimoire with `tokenId` and transfers it to `recipient`.
    function print(address recipient, uint256 tokenId) external;

    /**
     * @dev Registers the given public key of `msg.sender` onto the contract.
     * Reverts if the public key does not belong to `msg.sender`.
     * @param publicKeyX X coordinate of the public key.
     * @param publicKeyY Y coordinate of the public key.
     */
    function register(bytes32 publicKeyX, bytes32 publicKeyY) external;
    
    /**
     * @dev Transfers a grimoire to a stealth address.
     * 
     * Emits a {StealthTransfer} event. This provides the 
     * necessary information for the true recipient to 
     * compute the private key to `stealthRecipient` address.
     * 
     * @param stealthRecipient Stealth address to transfer the token to.
     * @param tokenId Token id of the grimoire to transfer.
     * @param publishedDataX X coordinate of the published data.
     * @param publishedDataY Y coordinate of the published data.
     */
    function stealthTransfer(
        address stealthRecipient, 
        uint256 tokenId,
        bytes32 publishedDataX,
        bytes32 publishedDataY
    ) external;

    /**
     * @dev Generates a stealth address and its published data. 
     * This should be called off-chain.
     * 
     * Should revert if the given `recipientAddress` has not 
     * had their public keys registered.
     *
     * @param recipientAddress Address of the true recipient.
     * @param secret Secret value decided by the sender.
     *
     * @return stealthAddress Generated stealth address.
     * @return publishedDataX X coordinate of the published data.
     * @return publishedDataY Y coordinate of the published data.
     */
    function getStealthAddress(
        address recipientAddress, 
        uint256 secret
    ) external view returns (
        address stealthAddress, 
        bytes32 publishedDataX,
        bytes32 publishedDataY
    );

}
