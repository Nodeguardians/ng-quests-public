// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/Elaine.sol";
import "../../../contracts/test/Token.sol";

abstract contract TestElaine is Test {

    using stdJson for string;
    
    struct CatData {
        uint256 amount;
        uint256 divisions;
        uint256 duration;
        address recipient;
    }
    
    uint256 constant ROUNDING_ERROR = 0.001 ether;

    CatData catData;

    Elaine elaine;
    Token token;
    SpiritCat cat;

    constructor(string memory _testDataPath) {
        bytes memory rawData = vm.readFile(_testDataPath).parseRaw("");
        catData = abi.decode(rawData, (CatData));

        elaine = new Elaine();
        token = new Token(address(elaine));
    }

    function setUp() external {
        vm.recordLogs();
        elaine.summon(
            catData.recipient,
            IERC20(token),
            catData.amount,
            catData.duration
        );

        // Extract address from event
        Vm.Log memory summonLog = _getEventLog("EscrowSummoned(address)");
        cat = SpiritCat(abi.decode(summonLog.data, (address)));

    }

    function test_summon_new_cat() external {
        uint256 catContractSize;
        address catAddress = address(cat);
        assembly {
            catContractSize := extcodesize(catAddress)
        }
        assertGt(catContractSize, 0, "SpiritCat is not a contract");
    }
    
    function test_deploy_cats_that_hold_tokens() external {
        assertTrue(
            token.balanceOf(address(cat)) > 0,
            "Spirit Cat has no balance"
        );
    }
    
    function test_deploy_cats_with_full_withdrawal() external {
        skip(catData.duration);
        vm.prank(catData.recipient);
        cat.withdraw();

        Vm.Log memory transferLog = _getEventLog("Transfer(address,address,uint256)");

        _assertTransfer(
            transferLog, 
            address(cat), 
            catData.recipient, 
            catData.amount,
            0
        );

    }

    function test_deploy_cats_with_correct_unlocked_balance() external {

        uint256 divided = catData.amount / catData.divisions;

        bool hasFailed;
        for (uint256 i = 1; i <= catData.divisions; i++) {
            skip(catData.duration / catData.divisions);

            bool pass = _isApproxEqual(cat.unlockedBalance(), i * divided, ROUNDING_ERROR);
            if (!pass) {
                hasFailed = true;
                break;
            }
        }

        skip(catData.duration / 2);
        if (cat.unlockedBalance() != catData.amount) { 
            console.log(cat.unlockedBalance());
            hasFailed = true; 
        }

        assertTrue(!hasFailed, "Incorrect unlocked balance");
    }

    function test_deploy_cats_with_partial_withdrawal() external {
        skip(catData.duration / 2);
        vm.startPrank(catData.recipient);
        cat.withdraw();
        vm.stopPrank();

        Vm.Log memory transferLog = _getEventLog("Transfer(address,address,uint256)");
        _assertTransfer(
            transferLog, 
            address(cat),
            catData.recipient, 
            catData.amount / 2,
            ROUNDING_ERROR
        );
    }
    
    function test_deploy_cats_that_lock_after_partial_withdrawal() external {
        skip(catData.duration / 2);
        vm.prank(catData.recipient);
        cat.withdraw();

        vm.expectRevert();
        cat.withdraw();
    }
    
    function test_deploy_cats_only_allow_recipient_to_withdraw() external {
        vm.expectRevert();
        cat.withdraw();
    }
    
    function test_dispel_cats() external {
        vm.expectRevert();
        vm.prank(catData.recipient);
        elaine.dispel(address(cat));

        elaine.dispel(address(cat));
        Vm.Log memory transferLog = _getEventLog("Transfer(address,address,uint256)");
        _assertTransfer(
            transferLog, 
            address(cat),
            address(elaine), 
            catData.amount,
            0
        );

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

    function _assertTransfer(
        Vm.Log memory _transferLog,
        address _from,
        address _to,
        uint256 _amount,
        uint256 _roundingError
    ) private {
        address from = address(uint160(uint256(_transferLog.topics[1])));
        address to = address(uint160(uint256(_transferLog.topics[2])));
        uint256 amount = abi.decode(_transferLog.data, (uint256));

        assertTrue(
            _from == from
            && _to == to
            && _isApproxEqual(amount, _amount, _roundingError),
            "Unexpected Transfer"
        );
    }

    function _isApproxEqual(
        uint256 _a, 
        uint256 _b, 
        uint256 _roundingError
    ) private returns (bool) {
        if (_a < _b) { return _isApproxEqual(_b, _a, _roundingError); } 
        return _a - _b <= _roundingError;
    }

}