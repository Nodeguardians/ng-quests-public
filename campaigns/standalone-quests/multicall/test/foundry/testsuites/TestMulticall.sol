// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/GreaterArchives.sol";

contract TestMulticall is Test {

    using stdJson for string;

    struct SingleCall {
        uint256[] args;
        string sig;
    }
    
    string jsonData;
    bytes[] readCalls;
    bytes[] writeCalls;

    bytes[] expectedReads;
    bytes[] expectedReturns;

    address callee;
    address referenceCallee;

    constructor(
        address _callee,
        address _referenceCallee,
        string memory _testDataKey
    ) {
        jsonData = vm.readFile(_testDataKey);

        callee = _callee;
        referenceCallee = _referenceCallee;

        writeCalls = _encodedCalls(".testWrites");
        readCalls = _encodedCalls(".testReads");

        for (uint i = 0; i < writeCalls.length; i++) {
            (bool success, bytes memory data) 
                = referenceCallee.call(writeCalls[i]);
            require(success, "TEST ERROR: Reference Write Call failed");
            expectedReturns.push(data);
        }

        for (uint i = 0; i < readCalls.length; i++) {
            (bool success, bytes memory data) 
                = referenceCallee.call(readCalls[i]);
            require(success, "TEST ERROR: Reference Read Call failed");
            expectedReads.push(data);
        }
    }

    function test_batch_transactions_in_multicall() external {

        // Call multicall()
        bytes[] memory returnData = Multicall(callee).multicall(writeCalls);
    
        // Verify data is written correctly
        for (uint i = 0; i < readCalls.length; i++) {

            (bool success, bytes memory actual) 
                = callee.staticcall(readCalls[i]);
            require(success, "Call processed incorrectly");

            assertEq(actual, expectedReads[i], "Call processed incorrectly");

        }

        // Check return values are forwarded correctly
        assertTrue(
            returnData.length == expectedReturns.length, 
            "Unexpected number of return values"
        );

        for (uint i = 0; i < writeCalls.length; i++) {
            assertEq(returnData[i], expectedReturns[i], 
                "Unexpected return value forwarded");
        }

    }

    function test_revert_on_failed_calls() external {
        bytes[] memory invalidCalls = _encodedCalls(".invalidCalls");
        vm.expectRevert();
        Multicall(callee).multicall(invalidCalls);
    }

    ////
    // ENCODING HELPER FUNCTIONS
    ////

    function _encodedCalls(
        string memory _key
    ) private view returns (bytes[] memory) {
        SingleCall[] memory calls = abi.decode(
            jsonData.parseRaw(_key),
            (SingleCall[])
        );

        bytes[] memory encoded = new bytes[](calls.length);
        for (uint i = 0; i < calls.length; i++) {
            encoded[i] = _encodeCall(calls[i]);
        }

        return encoded;
    }
    
    function _encodeCall(
        SingleCall memory call
    ) private pure returns (bytes memory) {

        bytes memory encoded = abi.encodePacked(
            bytes4(keccak256(bytes(call.sig)))
        );

        for (uint i = 0; i < call.args.length; i++) {
            encoded = bytes.concat(encoded, abi.encode(call.args[i]));
        }

        return encoded;
    }
}