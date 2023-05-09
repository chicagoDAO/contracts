const tokenAddr = '0x0085Ca8b153fD2Fe2D98a201C4f0a118f1124B89'
// open main asynchronous function will handle deployment
const main = async () => {
  try {
    const gas = await ethers.provider.getGasPrice()
    // use hre object that allows us to pass the name of our contract to getContractFactory
    const DGIDGOVERNOR = await ethers.getContractFactory(
      "DGIDGovernor"
    );

    const DGIDGovernor = await upgrades.deployProxy(DGIDGOVERNOR, ["DGID", tokenAddr], { gasPrice: gas, initializer: 'initialize' });

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

