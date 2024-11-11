const hre = require("hardhat");

async function main() {
    const CBToken = await hre.ethers.getContractFactory("CBToken");
    const cbToken = await CBToken.deploy();

    await cbToken.waitForDeployment();

    console.log("CBToken deployed to:", await cbToken.getAddress());
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
