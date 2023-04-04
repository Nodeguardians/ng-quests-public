// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/Mind.sol";

contract PublicTest1 is Test {

    Mind mind;

    constructor() {
        mind = new Mind();
    }

    function test_detect_delegate_calls() external {
        (bool result, bytes memory _returnData) = address(mind).delegatecall(
            abi.encodeWithSignature("isDelegateCall()")
        );

        assertTrue(result, "Delegate call failed");
        
        bool isDelegate = abi.decode(_returnData, (bool));

        assertTrue(isDelegate, "Failed to detect delegate call");
    }

    function test_detect_non_delegate_calls() external {
        bool isDelegate = mind.isDelegateCall();
        assertTrue(!isDelegate, "Failed to detect non-delegate call");
    }

}