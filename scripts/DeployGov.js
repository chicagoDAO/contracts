const tokenAddr = '0x5BAfEf740904fd4EEE7A5D5C1F7D732e4F4aA33E'
// open main asynchronous function will handle deployment
const main = async () => {
  try {
    // use hre object that allows us to pass the name of our contract to getContractFactory
    const DGIDGOVERNOR = await ethers.getContractFactory(
      "DGIDGovernor"
    );

    const DGIDGovernor = await upgrades.deployProxy(DGIDGOVERNOR, ["DGID", tokenAddr]);

    // log the address of the Contract in our console
    console.log("Contract deployed to:", DGIDGovernor.address);
    process.exit(0);

    // catch error, if any, and log in console
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();

