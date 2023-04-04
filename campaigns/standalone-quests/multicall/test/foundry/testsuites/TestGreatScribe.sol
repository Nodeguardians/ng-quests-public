// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/GreatArchives.sol";
import "../../../contracts/GreatScribe.sol";

contract TestGreatScribe is Test {

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

    GreatScribe scribe;

    constructor(
        address _callee,
        address _referenceCallee,
        string memory _testDataKey
    ) {
        jsonData = vm.readFile(_testDataKey);

        scribe = new GreatScribe();
        callee = _callee;
        referenceCallee = _referenceCallee;

        writeCalls = _encodedCalls(".testWrites");
        readCalls = _encodedCalls(".testReads");

        for (uint i = 0; i < writeCalls.length; i++) {
            (bool success, bytes memory data) 
                = referenceCallee.call(writeCalls[i]);
            require(success, "TEST ERROR: Reference write call failed");
            expectedReturns.push(data);
        }

        for (uint i = 0; i < readCalls.length; i++) {
            (bool success, bytes memory data) 
                = referenceCallee.staticcall(readCalls[i]);
            require(success, "TEST ERROR: Reference read call failed");

            expectedReads.push(data);
        }
    }

    function test_batch_read_calls_in_multiread() external {

        bytes[] memory readValues = scribe.multiread(
            readCalls,
            referenceCallee
        );

        for (uint i = 0; i < readCalls.length; i++) {
            assertEq(readValues[i], expectedReads[i], "Unexpected Read Value");
        }   

    }

    function test_revert_on_failed_calls_in_multiread() external {
        bytes[] memory invalidCalls = _encodedCalls(".invalidReads");
        vm.expectRevert();
        scribe.multiread(invalidCalls, referenceCallee);
    }

    function test_batch_write_calls_in_multiwrite() external {

        bytes[] memory returnValues = scribe.multiwrite(
            writeCalls,
            callee
        );

        // Check return values are forwarded correctly
        assertTrue(
            returnValues.length == expectedReturns.length, 
            "Unexpected number of return values"
        );
        for (uint i = 0; i < writeCalls.length; i++) {
            assertEq(returnValues[i], expectedReturns[i], "Unexpected Return Value");
        }   

        for (uint i = 0; i < readCalls.length; i++) {
            (bool success, bytes memory actual) = callee.call(readCalls[i]);
            require(success, "TEST ERROR: Read Call failed");
            
            assertEq(actual, expectedReads[i], "Call not processed correctly");
        }   

    }

    function test_revert_on_failed_calls_in_multiwrite() external {
        bytes[] memory invalidCalls = _encodedCalls(".invalidWrites");
        vm.expectRevert();
        scribe.multiwrite(invalidCalls, referenceCallee);
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