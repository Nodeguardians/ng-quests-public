// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/Doubloon.sol";

abstract contract TestDoubloonEvents is Test {
    using stdJson for string;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

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

    function test_emit_transfer_on_transfer() external {
        vm.prank(creator);

        vm.expectEmit();
        emit Transfer(creator, user1, input.transferAmount1);

        doubloon.transfer(user1, input.transferAmount1);
    }

    function test_emit_approval_on_approve() external {
        vm.prank(creator);

        vm.expectEmit();
        emit Approval(creator, user1, input.transferAmount1);

        doubloon.approve(user1, input.transferAmount1);
    }

    function test_emit_transfer_on_transferfrom() external {
        vm.prank(creator);
        doubloon.approve(user1, input.transferAmount1);

        vm.prank(user1);
        vm.expectEmit();
        emit Transfer(creator, user1, input.transferAmount1);

        doubloon.transferFrom(creator, user1, input.transferAmount1);
    }
}
