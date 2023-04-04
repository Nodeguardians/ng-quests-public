// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

contract PublicTest1 is Test {

    using stdJson for string;
    address TARGET_ADDRESS = 0xB9c8ec9cE5e018A7973d57AE1c74C6E697aC0D96;

    // Private key: 0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef
    // Secret: 0x12341234
    function test_private_key_to_recipient_address() external {
        uint256 stealthKey = vm.readFile("output/stealthRecipient.json")
            .readUint(".privateKey");

        assertEq(vm.rememberKey(stealthKey), TARGET_ADDRESS, "Incorrect key");
    }
}
