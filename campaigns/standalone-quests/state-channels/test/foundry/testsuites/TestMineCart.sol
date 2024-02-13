// SPDX-License-Identifier:MineCart MIT
pragma solidity ^0.8.20;

import "../../../contracts/MineCart.sol";
import "../../../contracts/interfaces/IMineCart.sol";
import "forge-std/Test.sol";

abstract contract TestMineCart is Test {
    using stdJson for string;

    IMineCart mineCart;
    address worker1;
    uint256 worker1Key;
    address worker2;
    uint256 worker2Key;

    struct Input {
        uint256[] loads;
        uint256[] ores;
        uint256 timePerMove;
    }

    Input input;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);

        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        (worker1, worker1Key) = makeAddrAndKey("worker1");
        (worker2, worker2Key) = makeAddrAndKey("worker2");
    }

    function setUp() public {
        mineCart = IMineCart(address(
            new MineCart{value: 10 ether}(
                payable(worker1),
                payable(worker2),
                input.timePerMove
            )
        ));
    }

    function test_updateStateWithSignature() external {
        
        _updateWithSignature(2);

        assertEq(mineCart.totalOres(), input.ores[2]);
        assertEq(mineCart.messageNum(), 3);

        _updateWithSignature(5);

        assertEq(mineCart.totalOres(), input.ores[5]);
        assertEq(mineCart.messageNum(), 6);

    }

    function test_rewardWinner_whenUpdate_totalOresOver20() external {

        _updateWithSignature(3);

        uint256 winningTurn = input.ores.length - 1;
        address winner = winningTurn % 2 == 1 ? worker1 : worker2;

        _updateWithSignature(winningTurn);

        assertEq(winner.balance, 10 ether);
        assertFalse(mineCart.isActive());
    }

    function test_load() external {

        uint256 totalOres = 0;
        for (uint i = 0; i < input.loads.length; i++) {
            address activeWorker = i % 2 == 0 ? worker1 : worker2;
            vm.prank(activeWorker);

            totalOres += input.loads[i];
            if (totalOres % 5 == 0) {
                totalOres -= 2;
            }

            mineCart.load(input.loads[i]);

            assertEq(mineCart.totalOres(), totalOres);

            if (totalOres < 21) {
                assertEq(mineCart.messageNum(), i + 2);
            }
        }

    }
    
    function test_load_moreThan4AtOnce_fail() external {
        vm.expectRevert();
        vm.prank(worker1);

        mineCart.load(5);
    }

    function test_rewardWinner_whenLoad_totalOresOver20() external {

        for (uint i = 0; i < input.loads.length; i++) {
            address activeWorker = i % 2 == 0 ? worker1 : worker2;
            vm.prank(activeWorker);

            mineCart.load(input.loads[i]);

        }

        uint256 winningTurn = input.loads.length - 1;
        address winner = winningTurn % 2 == 1 ? worker2 : worker1;

        assertEq(winner.balance, 10 ether);
        assertFalse(mineCart.isActive());
    }

    function test_timeOut() external {
        // Time out 1 turn before winning turn
        uint256 lastTurn = input.ores.length - 1;
        _updateWithSignature(lastTurn - 1);

        vm.expectRevert();
        mineCart.timeOut();

        vm.warp(block.timestamp + input.timePerMove + 1);

        // Time out and check non-active worker is rewarded
        address winner = lastTurn % 2 == 1 ? worker2 : worker1;

        mineCart.timeOut();

        assertEq(winner.balance, 10 ether);
        assertFalse(mineCart.isActive());
    }

    function test_badSignature_fail() external {
        bytes memory message = abi.encodePacked(
            "\x19Ethereum Signed Message:\n84",
            address(mineCart),
            input.ores[3],
            uint256(3)
        );

        bytes32 unsignedHash = keccak256(message);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(worker1Key, unsignedHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectRevert();
        vm.prank(worker1);
        mineCart.update(
            input.ores[3], 
            3,
            signature
        );
    }

    function test_oldMessageNum_fail() external {
        _updateWithSignature(5);

        vm.expectRevert();
        _updateWithSignature(3);
    }

    function _updateWithSignature(uint256 _messageNum) private {
        bytes memory message = abi.encodePacked(
            "\x19Ethereum Signed Message:\n84",
            address(mineCart),
            input.ores[_messageNum],
            _messageNum
        );

        (address sender, uint256 signerKey) = (_messageNum % 2 == 0)
            ? (worker2, worker1Key)
            : (worker2, worker1Key);

        bytes32 unsignedHash = keccak256(message);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerKey, unsignedHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.prank(sender);
        mineCart.update(
            input.ores[_messageNum], 
            _messageNum,
            signature
        );
    }

}
