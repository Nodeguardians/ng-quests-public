const { ethers } = require("hardhat");

/**
 * Returns a personal signature approving the invite of a recipient to become grandmaster.
 *
 * @param {string<Address>} recipientAddress Address of recipient.
 * @param {ethers.Signer} signer To sign message with.
 *
 * @return {string} Signature.
 */
function approveInvitation(recipientAddress, signer) {
    // COMPLETE THIS FUNCTION
}

/**
 * Returns a personal signature appoving a recipient to receive a blessing in wei from the contract.
 *
 * @param {string} recipientAddress Address of recipient.
 * @param {ethers.BigNumber} amount Amount of wei for recipient to receive.
 * @param {number} ctr Number of blessings the recipient has previously received.
 * @param {ethers.Signer} signer To sign message with.
 *
 * @return {string} Signature.
 */
function approveBlessing(recipientAddress, amount, ctr, signer) {
    // COMPLETE THIS FUNCTION
}

// Exports function out for our test scripts
module.exports.approveInvitation = approveInvitation;
module.exports.approveBlessing = approveBlessing;