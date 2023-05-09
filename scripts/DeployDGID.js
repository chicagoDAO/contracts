const multisig = "0x0EdD3EE977bDdf18eAa3548eC8544B78c78F40e5";
const main = async () => {
  const { ethers, upgrades } = require("hardhat");
  try {

    const DGID = await ethers.getContractFactory("DGID");
    console.log("DGID deploying...");
    const dgid = await upgrades.deployProxy(DGID, ["DGID", "ChicagoDAO", "1.0.1"], { initializer: "initialize" });
    console.log("Contract deployed to:", dgid.address);
    process.exit(0);

  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
