// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/MintableDoubloon.sol";

interface IMintable is IERC20 {
    function mint(address _to, uint256 _amount) external;
}

abstract contract TestMintableDoubloon is Test {
    using stdJson for string;
    
    event Transfer(address indexed from, address indexed to, uint256 value);

    IMintable mdoubloon;

    struct Input {
        uint256 mintAmount;
        uint256 supply;
    }
    Input input;

    address payable creator;
    address payable user2;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        address creator1 = makeAddr("creator");
        address user2_1 = makeAddr("user2");
        creator = payable(creator1);
        user2 = payable(user2_1);
    }

    function setUp() public {
        hoax(creator, 1 ether);
        vm.deal(user2, 1 ether);

        mdoubloon = IMintable(address(new MintableDoubloon(input.supply)));
    }

    function test_mint_doubloons() external {
        vm.prank(creator);

        vm.expectEmit();
        emit Transfer(address(0), user2, input.mintAmount);

        mdoubloon.mint(user2, input.mintAmount);

        assertEq(mdoubloon.totalSupply(), input.supply + input.mintAmount);
        assertEq(mdoubloon.balanceOf(user2), input.mintAmount);
    }

    function test_invalid_mint_doubloons() external {
        vm.prank(user2);

        vm.expectRevert();
        mdoubloon.mint(user2, input.mintAmount);
    }
}
