require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-chai-matchers");
require("hardhat-ignore-warnings");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 100,
    },
  },
  warnings: {
    "*": {
      "code-size": "off",
    },
  },
};
