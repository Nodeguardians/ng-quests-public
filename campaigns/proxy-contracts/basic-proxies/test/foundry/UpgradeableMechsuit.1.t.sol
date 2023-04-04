// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/UpgradeableMechSuit.sol";
import "../../contracts/MechSuitV1.sol";
import "../../contracts/MechSuitV2.sol";

contract PublicTest1 is Test {

    address public suitLogic1;
    address public suitLogic2;
    address public suit;

    constructor() {
        suitLogic1 = address(new MechSuitV1());
        suitLogic2 = address(new MechSuitV2());

        suit = address(new UpgradeableMechSuit(suitLogic1));
    }

    function test_forward_calls_to_delegate() external {
        MechSuitV1(suit).refuel{ value: 1 gwei }(); 

        bytes32 hammerHash = MechSuitV1(suit).swingHammer();
        assertEq(hammerHash, keccak256("HAMMER SMASH!!!"), "Bad hammer smash");

        assertEq(MechSuitV1(suit).fuel(), 90, "Bad fuel level");

        MechSuitV2(suit).refuel{ value: 1 gwei }();
        vm.expectRevert();
        MechSuitV2(suit).blastCannon();
    } 

    function test_upgradeable() external {
        UpgradeableMechSuit(payable(suit)).upgradeTo(suitLogic2);

        MechSuitV2(suit).refuel{ value: 1 gwei }();

        bytes32 cannonHash = MechSuitV2(suit).blastCannon();
        assertEq(cannonHash, keccak256("BOOM!"), "Bad cannon blast");

    }

}