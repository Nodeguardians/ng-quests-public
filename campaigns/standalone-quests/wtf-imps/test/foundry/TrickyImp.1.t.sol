// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/TrickyImp.sol";

contract PublicTest1 is Test {

    function test_attack_itself() external {
        TrickyImp trickyImp = new TrickyImp();
        require(trickyImp.attack() == Imp.Target.Self, "Should attack itself");
    }

}
