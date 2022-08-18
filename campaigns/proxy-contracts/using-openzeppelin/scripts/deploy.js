const { ethers, upgrades } = require("hardhat");

/**
 * Deploys an OpenZeppelin proxy implementing UltimateSuitV1.
 *
 * @param {number} threshold Threshold to initialize suit with.
 *
 * @return {ethers.Contract} Deployed proxy.
 */
async function deploy(threshold) {
    // CODE HERE
}

// Exports function out for our test scripts
module.exports.deploy = deploy;