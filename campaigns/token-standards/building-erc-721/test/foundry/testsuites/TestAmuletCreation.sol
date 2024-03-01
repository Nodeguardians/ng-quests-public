// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/Amulet.sol";

interface IMintable is IERC721, IERC721Metadata {
    function mint(address _to, string memory _tokenURI) external returns (uint256);
}

abstract contract TestAmuletCreation is Test {
    using stdJson for string;

    IMintable amulet;

    struct Input {
        string uri;
    }
    Input input;

    address creator;
    address user2;

    bytes4 constant ERC165_ID = 0x01ffc9a7;
    bytes4 constant ERC721_ID = 0x80ac58cd;
    bytes4 constant ERC721_METADATA_ID = 0x5b5e139f;
    bytes4 constant ERC721_TOKEN_RECEIVER_ID = 0x150b7a02;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        creator = makeAddr("creator");
        user2 = makeAddr("user2");
    }

    function setUp() public {
        vm.prank(creator);
        amulet = IMintable(address(new Amulet()));
    }

    function test_have_name_and_symbol() external {
        assertEq(amulet.name(), "Amulet");
        assertEq(amulet.symbol(), "AMULET");
    }

    function test_mint_token() external {
        vm.prank(creator);
        uint256 amuletID = amulet.mint(user2, input.uri);

        assertEq(amulet.tokenURI(amuletID), input.uri);
        assertEq(amuletID, 0);

        vm.prank(creator);
        amuletID = amulet.mint(user2, input.uri);
        assertEq(amuletID, 1);
    }

    function test_ownerOf_and_balanceOf() external {
        vm.startPrank(creator);
        amulet.mint(user2, input.uri);
        amulet.mint(user2, input.uri);

        assertEq(amulet.balanceOf(user2), 2);
        assertEq(amulet.ownerOf(0), user2);
        assertEq(amulet.ownerOf(1), user2);

        vm.expectRevert();
        amulet.ownerOf(2);
        vm.expectRevert();
        amulet.balanceOf(address(0));
    }

    function test_prevent_nonowner_minting() external {
        vm.prank(user2);

        vm.expectRevert();
        amulet.mint(creator, input.uri);
    }

    function test_revert_invalid_token() external {
        vm.expectRevert();
        amulet.tokenURI(12345);
    }

    function test_supports_correct_interfaces() external {
        assertEq(amulet.supportsInterface(ERC165_ID), true);
        assertEq(amulet.supportsInterface(ERC721_ID), true);
        assertEq(amulet.supportsInterface(ERC721_METADATA_ID), true);
        assertEq(amulet.supportsInterface(ERC721_TOKEN_RECEIVER_ID), false);
    }
}
