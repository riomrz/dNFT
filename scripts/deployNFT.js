const hre = require("hardhat");
require("dotenv").config({ path: ".env" });


const name = "Metal Slug dNFT";
const symbol = "MSD";

async function main() {
    // Token deploy
    const MydNFT = await hre.ethers.getContractFactory("MydNFT");
    console.log("Deploying Token contract...");
    const mydNFT = await MydNFT.deploy(name, symbol, 1000);
    await mydNFT.waitForDeployment();
    console.log("Token contract deployed @:", mydNFT.target);

    // Mint a dNFT on my test wallet (mint manually on etherscan)
    // mydNFT.safeMint(process.env.TEST_WALLET_ADDRESS);
    // console.log("Minted a dNFT on wallet: ", process.env.TEST_WALLET_ADDRESS);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });