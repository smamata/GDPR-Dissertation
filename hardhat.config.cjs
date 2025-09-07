require("dotenv/config");
require("@nomicfoundation/hardhat-toolbox");

const SEPOLIA_URL = process.env.SEPOLIA_RPC_URL || "";
const POLYGON_AMOY_URL = process.env.POLYGON_AMOY_RPC_URL || ""; // Amoy testnet
const ARBITRUM_SEPOLIA_URL = process.env.ARBITRUM_SEPOLIA_RPC_URL || "";
const PRIVATE_KEY = process.env.DEPLOYER_PRIVATE_KEY || "";

const accounts = PRIVATE_KEY !== "" ? [PRIVATE_KEY] : [];

/** @type {import('hardhat/config').HardhatUserConfig} */
const config = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: { enabled: true, runs: 200 },
    },
  },
  networks: {
    hardhat: {},
    sepolia: { url: SEPOLIA_URL, accounts },
    polygonAmoy: { url: POLYGON_AMOY_URL, accounts },
    arbitrumSepolia: { url: ARBITRUM_SEPOLIA_URL, accounts },
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.ETHERSCAN_API_KEY || "",
      polygonAmoy: process.env.POLYGONSCAN_API_KEY || "",
      arbitrumSepolia: process.env.ARBISCAN_API_KEY || "",
    },
  },
};

module.exports = config;


