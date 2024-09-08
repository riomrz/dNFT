require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({ path: ".env" });


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    }
  },

  networks: {
    hardhat: {},
    dashboard: {
      url: "http://localhost:24012/rpc",
    },
    sepolia: {
      url: `https://eth-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_SEPOLIA_KEY}`,
      accounts: "remote",
    },
    amoy: {
      url: `https://polygon-amoy.g.alchemy.com/v2/${process.env.ALCHEMY_AMOY_KEY}`,
      accounts: "remote",
    }
  },

  paths: {
    sources: './contracts',
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },

  mocha: {
    timeout: 40000
  },

  etherscan: {
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY,
    }
  },

  sourcify: {
    enabled: true
  }
};
