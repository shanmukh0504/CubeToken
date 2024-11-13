const hre = require("hardhat");

async function main() {
    const CubeToken = await hre.ethers.getContractFactory("CubeToken");
    const cbToken = await CubeToken.deploy();

    console.log("CubeToken deployed to:", await cbToken.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
