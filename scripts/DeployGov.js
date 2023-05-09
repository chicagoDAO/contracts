const tokenAddr = "0x394B9e988A1686a7aFaD6ae3DF29aa3471C2710a";
const main = async () => {
  try {
    const DGIDGOVERNOR = await ethers.getContractFactory("DGIDGovernor");
    console.log("DGIDGovernor deploying...");
    const DGIDGovernor = await upgrades.deployProxy(DGIDGOVERNOR, ["DGID", tokenAddr], {
      initializer: "initialize",
    });
    console.log("Contract deployed to:", DGIDGovernor.address);
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
