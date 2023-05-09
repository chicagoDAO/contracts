const multisig = "0x0EdD3EE977bDdf18eAa3548eC8544B78c78F40e5";
const main = async () => {
  const { ethers, upgrades } = require("hardhat");
  try {
    const gas = await ethers.provider.getGasPrice();

    // use hre object that allows us to pass the name of our contract to getContractFactory
    const DGID = await ethers.getContractFactory("DGID");
    console.log("gas price", gas);

    const dgid = await upgrades.deployProxy(
      DGID,
      ["DGID", "ChicagoDAO", "2.0.0", "0x0EdD3EE977bDdf18eAa3548eC8544B78c78F40e5"],
      {
        gasPrice: gas, constructorArgs: ["DGID", "ChicagoDAO", "1.0.0", "0x0EdD3EE977bDdf18eAa3548eC8544B78c78F40e5"],
        initializer: "initialize"
      },
    );

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
