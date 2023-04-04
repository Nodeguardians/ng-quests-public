// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts_/BanditCamp.sol";

contract ClearCamp is Script {

    // Input bandit camp address here
    BanditCamp constant CAMP = BanditCamp(0x0000000000000000000000000000000000000000);

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        CAMP.clearCamp();

        vm.stopBroadcast();
    }
}