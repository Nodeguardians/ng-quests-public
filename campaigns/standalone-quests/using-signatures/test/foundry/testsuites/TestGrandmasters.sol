// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Grandmasters.sol";

abstract contract TestGrandmasters is Test {

    using stdJson for string;

    struct TxTest {
        uint256 action;
        uint256 amount;
        address recipient;
        bool shouldRevert;
        bytes signature;
    }

    Grandmasters grandmasters;
    string jsonData;
    address creator;

    constructor(string memory _testDataPath) {
        jsonData = vm.readFile(_testDataPath);
        creator = jsonData.readAddress(".creator");
    }

    function setUp() external {
        hoax(creator);
        grandmasters = new Grandmasters{value: 1 ether}();
    } 

    function _runTests(
        string memory _testKey
    ) internal {
        bytes memory rawTests = jsonData.parseRaw(_testKey);
        TxTest[] memory tests = abi.decode(rawTests, (TxTest[]));

        for (uint256 i = 0; i < tests.length; i++) {
            if (tests[i].action == 0) {
                _runBlessTest(tests[i]);
            } else {
                _runInviteTest(tests[i]);
            }
        }
    }

    function _runInviteTest(TxTest memory _test) private {

        if (_test.shouldRevert) { vm.expectRevert(); }

        vm.prank(_test.recipient);
        grandmasters.acceptInvite(_test.signature);

        if (!_test.shouldRevert) {
            assertTrue(grandmasters.grandmasters(_test.recipient));
        }
    }

    function _runBlessTest(TxTest memory _test) private {
        
        uint256 initBalance = _test.recipient.balance;

        if (_test.shouldRevert) { vm.expectRevert(); } 

        vm.prank(_test.recipient);
        grandmasters.receiveBlessing(_test.amount, _test.signature);

        if (!_test.shouldRevert) {
            uint256 amountReceived = _test.recipient.balance - initBalance;
            assertEq(amountReceived, _test.amount, "Recipient did not receive Ether");
        }

    }
}
