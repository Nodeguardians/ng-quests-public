// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/Amulet.sol";
import "../../../contracts/test/ERC721DummyReceiver.sol";

interface IMintable is IERC721 {
    function mint(address _to, string calldata _tokenUri) external;
}

abstract contract TestAmuletTransfer is Test {
    using stdJson for string;

    IMintable amulet;

    struct Input {
        uint256 startId;
    }

    Input input;

    address creator;
    address user1;
    address user2;

    uint amuletID1;
    uint amuletID2;
    uint amuletID3;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        creator = makeAddr("creator");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
    }

    function setUp() public {
        vm.startPrank(creator);
        amulet = IMintable(address(new Amulet()));

        for (uint i = 0; i < input.startId; i++) {
            amulet.mint(creator, "https://url.com");
        }

        amuletID1 = input.startId;
        amuletID2 = input.startId + 1;
        amuletID3 = input.startId + 2;

        amulet.mint(user1, "https://url1.com");
        amulet.mint(user2, "https://url2.com");
        amulet.mint(user1, "https://url3.com");

        vm.stopPrank();
    }

    function test_transfer_amulet_directly() external {
        vm.prank(user1);
        amulet.transferFrom(user1, user2, amuletID1);

        assertEq(amulet.balanceOf(user2), 2);
        assertEq(amulet.balanceOf(user1), 1);

        assertEq(amulet.ownerOf(amuletID1), user2);
    }

    function test_transfer_amulet_indirectly_with_approval() external {
        // Approve
        vm.prank(user1);
        amulet.approve(user2, amuletID1);

        assertEq(amulet.getApproved(amuletID1), user2);

        // Transfer
        vm.prank(user2);
        amulet.transferFrom(user1, user2, amuletID1);

        // Check ownership is updated
        assertEq(amulet.ownerOf(amuletID1), user2);
        assertEq(amulet.balanceOf(user2), 2);
        assertEq(amulet.balanceOf(user1), 1);

        // Check approval is removed
        assertEq(amulet.getApproved(amuletID1), address(0), "Approval not cleared!");
    }

    function test_transfer_amulet_indirectly_with_authorized_operator() external {
        // Set approval for all
        vm.prank(user1);
        amulet.setApprovalForAll(user2, true);

        // Transfer
        vm.startPrank(user2);
        amulet.transferFrom(user1, user2, amuletID1);
        amulet.transferFrom(user1, user2, amuletID3);
        vm.stopPrank();

        // Check ownership is updated
        assertEq(amulet.ownerOf(amuletID1), user2);
        assertEq(amulet.ownerOf(amuletID3), user2);
        assertEq(amulet.balanceOf(user2), 3);
        assertEq(amulet.balanceOf(user1), 0);
    }

    function test_reject_unauthorized_transferFrom() external {
        vm.prank(user1);
        amulet.approve(user2, amuletID1);

        vm.prank(user2);
        vm.expectRevert();
        amulet.transferFrom(user1, user2, amuletID2);

        vm.prank(user2);
        vm.expectRevert();
        amulet.transferFrom(user1, user2, amuletID3);
    }

    function test_reject_transfer_to_zero_address() external {
        vm.prank(user1);
        vm.expectRevert();
        amulet.transferFrom(user1, address(0), amuletID1);
    }
}

abstract contract TestAmuletSafeTransfer is Test {
    using stdJson for string;

    IMintable amulet;

    struct Input {
        uint256 startId;
    }

    Input input;

    address creator;
    address user1;
    address user2;

    uint amuletID1;
    uint amuletID2;
    uint amuletID3;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));

        creator = makeAddr("creator");
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
    }

    function setUp() public {
        vm.startPrank(creator);
        amulet = IMintable(address(new Amulet()));

        for (uint i = 0; i < input.startId; i++) {
            amulet.mint(creator, "https://url.com");
        }

        amuletID1 = input.startId;
        amuletID2 = input.startId + 1;
        amuletID3 = input.startId + 2;

        amulet.mint(user1, "https://url1.com");
        amulet.mint(user2, "https://url2.com");
        amulet.mint(user1, "https://url3.com");
        vm.stopPrank();
    }

    function test_safeTransfer_amulet_directly() external {
        vm.prank(user1);
        amulet.transferFrom(user1, user2, amuletID1);

        assertEq(amulet.balanceOf(user2), 2);
        assertEq(amulet.balanceOf(user1), 1);

        assertEq(amulet.ownerOf(amuletID1), user2);
    }

    function test_safeTransfer_amulet_indirectly_with_approval() external {
        // Approve
        vm.prank(user1);
        amulet.approve(user2, amuletID1);

        assertEq(amulet.getApproved(amuletID1), user2);

        // Transfer
        vm.prank(user2);
        amulet.safeTransferFrom(user1, user2, amuletID1);

        // Check ownership is updated
        assertEq(amulet.ownerOf(amuletID1), user2);
        assertEq(amulet.balanceOf(user2), 2);
        assertEq(amulet.balanceOf(user1), 1);

        // Check approval is removed
        assertEq(amulet.getApproved(amuletID1), address(0), "Approval not cleared!");
    }

    function test_safeTransfer_amulet_indirectly_with_authorized_operator() external {
        // Set approval for all
        vm.prank(user1);
        amulet.setApprovalForAll(user2, true);

        // Transfer
        vm.startPrank(user2);
        amulet.safeTransferFrom(user1, user2, amuletID1);
        amulet.safeTransferFrom(user1, user2, amuletID3);
        vm.stopPrank();

        // Check ownership is updated
        assertEq(amulet.ownerOf(amuletID1), user2);
        assertEq(amulet.ownerOf(amuletID3), user2);
        assertEq(amulet.balanceOf(user2), 3);
        assertEq(amulet.balanceOf(user1), 0);
    }

    function test_reject_unauthorized_safeTransferFrom() external {
        vm.prank(user1);
        amulet.approve(user2, amuletID1);

        vm.prank(user2);
        vm.expectRevert();
        amulet.safeTransferFrom(user1, user2, amuletID2);

        vm.prank(user2);
        vm.expectRevert();
        amulet.safeTransferFrom(user1, user2, amuletID3);
    }

    function test_reject_safeTransfer_to_zero_address() external {
        vm.prank(user1);
        vm.expectRevert();
        amulet.safeTransferFrom(user1, address(0), amuletID1);
    }

    function test_safeTransfer_to_compatible_receiver() external {
        ERC721DummyReceiver receiver = new ERC721DummyReceiver();
        vm.prank(user1);
        amulet.safeTransferFrom(user1, address(receiver), amuletID1);

        assertEq(amulet.ownerOf(amuletID1), address(receiver));
    }

    function test_reject_safeTransfer_to_incompatible_receiver() external {
        ERC721DummyReceiver receiver = new ERC721DummyReceiver();
        receiver.pause();

        vm.prank(user1);
        vm.expectRevert();
        amulet.safeTransferFrom(user1, address(receiver), amuletID1);
    }

    function test_safeTransfer_with_data() external {
        ERC721DummyReceiver receiver = new ERC721DummyReceiver();

        bytes memory testData = abi.encodePacked("test data");
        vm.prank(user1);
        amulet.safeTransferFrom(user1, address(receiver), amuletID1, testData);

        assertEq(amulet.ownerOf(amuletID1), address(receiver));
        assertEq(receiver.data(), testData);
    }
}

abstract contract TestAmuletEvents is Test {

    event Approval(
        address indexed _owner, 
        address indexed _approved, 
        uint256 indexed _tokenId
    );

    event ApprovalForAll(
        address indexed _owner, 
        address indexed _operator, 
        bool _approved
    );

    event Transfer(
        address indexed _from, 
        address indexed _to,
        uint256 indexed _tokenId
    );


    IMintable amulet;

    address creator;
    address user2;

    uint amuletID1;
    uint amuletID2;

    constructor() {
        creator = makeAddr("creator");
        user2 = makeAddr("user2");
    }

    function setUp() public {
        vm.startPrank(creator);
        amulet = IMintable(address(new Amulet()));

        amuletID1 = 0;
        amuletID2 = 1;

        amulet.mint(creator, "https://url1.com");
        amulet.mint(creator, "https://url2.com");
        vm.stopPrank();
    }

    function test_emit_Approval_events() external {
        vm.prank(creator);
        vm.expectEmit();
        emit Approval(creator, user2, amuletID1);
        amulet.approve(user2, amuletID1);
    }

    function test_emit_ApprovalForAll_events() external {
        vm.prank(creator);
        vm.expectEmit();
        emit ApprovalForAll(creator, user2, true);
        amulet.setApprovalForAll(user2, true);
    }

    function test_emit_Transfer_events() external {
        vm.startPrank(creator);
        vm.expectEmit();
        emit Transfer(address(0), creator, 2);
        amulet.mint(creator, "https://url3.com");
        
        vm.expectEmit();
        emit Transfer(creator, user2, amuletID1);
        amulet.transferFrom(creator, user2, amuletID1);

        vm.expectEmit();
        emit Transfer(creator, user2, amuletID2);
        amulet.safeTransferFrom(creator, user2, amuletID2);

        vm.stopPrank();

        vm.prank(user2);
        vm.expectEmit();
        emit Transfer(user2, creator, amuletID2);
        amulet.safeTransferFrom(user2, creator, amuletID2, "");
    }
}
