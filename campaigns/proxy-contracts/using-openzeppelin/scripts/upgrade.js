const { ethers, upgrades } = require("hardhat");

/**
 * Upgrades an OpenZeppelin proxy implementing UltimateSuitV1 to implement UltimateSuitV2.
 *
 * @param {string} proxyAddress Address of proxy to upgrade.
 *
 * @return {ethers.Contract} Upgraded proxy.
 */
async function upgrade(proxyAddress) {
    // CODE HERE
}

// Exports function out for our test scripts
module.exports.upgrade = upgrade;