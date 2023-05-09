const main = async () => {
  try {
    const Gm = await ethers.getContractFactory("Gm");
    const GM = await Gm.deploy();
    console.log("Contract deployed to:", GM.address);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
