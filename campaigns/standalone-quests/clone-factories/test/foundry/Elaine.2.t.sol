// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/Elaine.sol";
import "../../contracts/test/Token.sol";

contract PublicTest1 is Test {

    string constant CAT_DATA_PATH = "test/data/catData.json";

    function test_summon_minimal_proxy_cat() external {
        Elaine elaine = new Elaine();
        Token token = new Token(address(elaine));

        vm.recordLogs();
        elaine.summon(
            0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
            IERC20(token),
            1 ether,
            100000
        );

        // Extract address from event
        Vm.Log memory summonLog = _getEventLog("EscrowSummoned(address)");
        address cat = abi.decode(summonLog.data, (address));

        uint256 catSize;
        assembly { catSize := extcodesize(cat) }
        assertLe(catSize, 90, "Cat is not a minimal proxy");

    }

    function _getEventLog(string memory _eventSig) private returns (Vm.Log memory) {

        Vm.Log[] memory logs = vm.getRecordedLogs();
        bytes32 expectedHash = keccak256(bytes(_eventSig));

        for (uint256 i = 0; i < logs.length; i++) {
            if (logs[i].topics[0] == expectedHash) {
                return logs[i];
            }
        }

        revert("Expected event not emitted");

    }

}