require("@nomiclabs/hardhat-ethers");
require("@nomicfoundation/hardhat-chai-matchers");

require("dotenv").config({ path: "../../../.env" });

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.19",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {}
  }
};
