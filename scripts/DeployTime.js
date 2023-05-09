// open main asynchronous function will handle deployment
const main = async () => {
  try {
    const MyGovernor = await ethers.getContractFactory("PopulusGovernor");
    console.log("Deploying PopulusGovernor");
    const myGovernor = await MyGovernor.deploy(
      1,
      4
    );
    const deployedGovernor = await myGovernor.deployed();
    console.log("MyGovernor deployed to:", myGovernor.address);

    // catch error, if any, and log in console
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
