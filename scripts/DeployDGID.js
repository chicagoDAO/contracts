// open main asynchronous function will handle deployment
const main = async () => {
  const { ethers, upgrades } = require("hardhat");
  try {
    // use hre object that allows us to pass the name of our contract to getContractFactory
    const DGID = await ethers.getContractFactory(
      "DGID"
    );
    console.log(upgrades)

    const dgid = await upgrades.deployProxy(DGID, ["DGID", "ChicagoDAO", "1.0.0"]);

    // create variable to allow us to use the deploy function of getContractFactory
    console.log("DGID deploying...");

    // log the address of the Contract in our console
    console.log("Contract deployed to:", dgid.address);
    process.exit(0);

    // catch error, if any, and log in console
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
