let DUMMY_ADDRESS = 0xA2BF76c361B78457D0FDaC42ba0A2FA53CEFE013;

task("test1", "Checks if player has found the main hall variable")
    .addParam("target", "The target contract's address")
    .setAction(async (taskArgs) => {
        Temple = await ethers.getContractFactory("Temple");
        temple = await Temple.attach(taskArgs.target);

        console.log("Result:", temple.mainHall == DUMMY_ADDRESS);
    });

task("test2", "Checks if player has found gardens[20][22]")
    .addParam("target", "The target contract's address")
    .setAction(async (taskArgs) => {
        Temple = await ethers.getContractFactory("Temple");
        temple = await Temple.attach(taskArgs.target);

        console.log("Result:", temple.gardens(20, 22) == DUMMY_ADDRESS);
    });

task("test3", "Checks if player has found chambers[5]")
    .addParam("target", "The target contract's address")
    .setAction(async (taskArgs) => {
        Temple = await ethers.getContractFactory("Temple");
        temple = await Temple.attach(taskArgs.target);

        console.log("Result:", temple.chambers(5) == DUMMY_ADDRESS);
    });