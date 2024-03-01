// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/Doubloon.sol";

abstract contract TestDoubloonTransfer is Test {

    using stdJson for string;

    IERC20 doubloon;

    struct Input {
        uint256 supply;
        uint256 transferAmount1;
        uint256 transferAmount2;
    }
    Input input;

    address creator;
    address user1;
    address user2;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        creator = makeAddr("creator");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
    }

    function setUp() public {
        vm.prank(creator);

        doubloon = IERC20(address(new Doubloon(input.supply)));
    }

    function test_have_balanceOf() external {
        assertEq(
            doubloon.balanceOf(creator), 
            input.supply,
            "Unexpected balance for creator!"
        );
    }

    function test_transfer_doubloons_with_transfer_func() external {
        vm.prank(creator);
        doubloon.transfer(user1, input.transferAmount1);

        assertEq(doubloon.totalSupply(), input.supply);
        assertEq(doubloon.balanceOf(user1), input.transferAmount1);
        assertEq(doubloon.balanceOf(creator), input.supply - input.transferAmount1);

        vm.prank(user1);
        bool result = doubloon.transfer(user2, input.transferAmount2);
        assertTrue(result);

        assertEq(
            doubloon.balanceOf(user1), 
            input.transferAmount1 - input.transferAmount2
        );
        assertEq(doubloon.balanceOf(user2), input.transferAmount2);
    }

    function test_reject_invalid_transfer() external {
        vm.prank(creator);
        vm.expectRevert();
        doubloon.transfer(user1, input.supply + 1);

        vm.prank(user2);
        vm.expectRevert();
        doubloon.transfer(user1, input.supply);
    }

    function test_approve_allowance() external {
        vm.prank(creator);
        doubloon.approve(user1, input.transferAmount1);

        assertEq(doubloon.allowance(creator, user1), input.transferAmount1);
    }

    function test_transfer_doubloons_with_transferFrom_func() external {
        vm.prank(creator);
        doubloon.approve(user1, input.transferAmount1);

        vm.prank(user1);
        bool result = doubloon.transferFrom(creator, user1, input.transferAmount1);
        assertTrue(result);

        assertEq(doubloon.totalSupply(), input.supply);
        assertEq(doubloon.balanceOf(user1), input.transferAmount1);
        assertEq(doubloon.balanceOf(creator), input.supply - input.transferAmount1);

        vm.prank(user1);
        doubloon.approve(user2, input.transferAmount2);

        vm.prank(user2);
        doubloon.transferFrom(user1, creator, input.transferAmount2);

        assertEq(
            doubloon.balanceOf(user1), 
            input.transferAmount1 - input.transferAmount2
        );
        assertEq(
            doubloon.balanceOf(creator), 
            input.supply - input.transferAmount1 + input.transferAmount2
        );
    }

    function test_decrease_allowance_after_transferFrom() external {
        vm.prank(creator);
        doubloon.approve(user1, input.transferAmount1);

        vm.prank(user1);
        doubloon.transferFrom(creator, user1, input.transferAmount1 -1);

        uint256 allowance = doubloon.allowance(creator, user1);
        assertEq(allowance, 1);
    }

    function test_reject_invalid_transferFrom_not_enough_funds() external {
        vm.prank(creator);
        doubloon.approve(user1, input.supply + 1);

        vm.prank(user1);
        vm.expectRevert();
        doubloon.transferFrom(creator, user1, input.supply + 1);
    }

    function test_reject_invalid_transferFrom_not_enough_allowance() external {
        vm.prank(creator);
        doubloon.approve(user1, input.supply - 1);

        vm.prank(user1);
        vm.expectRevert();
        doubloon.transferFrom(creator, user1, input.supply);

        vm.prank(user2);
        vm.expectRevert();
        doubloon.transferFrom(creator, user1, input.supply);
    }

}
