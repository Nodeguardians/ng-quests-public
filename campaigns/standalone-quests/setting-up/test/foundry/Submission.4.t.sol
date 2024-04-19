// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../contracts/HelloGuardian.sol";
import "forge-std/Test.sol";

contract PublicTest1 is Test {

    function testReadyToSubmit() external {
        HelloGuardian helloGuardian = new HelloGuardian();

        assertEq(
            helloGuardian.hello(),
            "Hello Guardian", 
            "Incorrect Result"
        );
    }

}
