require("@nomicfoundation/hardhat-toolbox");

require("dotenv").config();

module.exports = {
    solidity: "0.8.26",
    networks: {
        sepolia: {
            url: process.env.INFURA_SEPOLIA_ENDPOINT,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
    etherscan: {
        apiKey: process.env.etherscanApiKey
      },
};
