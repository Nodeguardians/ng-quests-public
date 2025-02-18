require("@nomicfoundation/hardhat-chai-matchers");
require("@matterlabs/hardhat-zksync-node");
require("@matterlabs/hardhat-zksync-deploy");
require("@matterlabs/hardhat-zksync-solc");

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      zksync: true,
    },
  },
  zksolc: {
    version: "1.4.1",
    settings: {
      isSystem: true,
    },
  },
  solidity: {
    version: "0.8.19",
  },
};
