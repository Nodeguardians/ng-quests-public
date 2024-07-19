require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-chai-matchers");

require("dotenv").config({ path: "../../../.env" });

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.19",
      },
      {
        version: "0.8.15",
      },
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    sepolia: {
      url: "https://rpc-sepolia-eth.nodeguardians.io",
      accounts: [process.env.PRIVATE_KEY],
    },
    "op-sepolia": {
      url: "https://optimism-sepolia.drpc.org",
      accounts: [process.env.PRIVATE_KEY],
    },
  },
  paths: {
    sources: "./contracts_",
  },
};
