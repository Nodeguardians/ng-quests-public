async function main() {
    // We get the contract to deploy
    const Temple = await ethers.getContractFactory("Temple");
    const temple = await Temple.deploy();
  
    await temple.deployed();
  
    console.log("Temple deployed to:", temple.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });