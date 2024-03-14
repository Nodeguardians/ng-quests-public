// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../../../contracts/interfaces/IERC721.sol";
import "../../../contracts/Amulet.sol";
import "../../../contracts/AmuletPouch.sol";

interface IMintable is IERC721 {
    function mint(address to, string memory tokenURI) external;
}

abstract contract TestAmuletPouch is Test {

    event WithdrawRequested(address indexed requester, uint256 indexed tokenId, uint256 indexed requestId);

    using stdJson for string;

    struct WithdrawRequest {
        uint256 requesterId;
        uint256 withdrawalId;
    }

    struct Input {
        uint256 approvedRequestId;
        uint256 numMembers;
        WithdrawRequest[] withdrawRequests;
    }

    IMintable amulet;
    IAmuletPouch amuletPouch;

    address creator;
    address[] users;
    uint256 totalAmulets;

    // Input
    uint256 approvedRequestId;
    uint256 numMembers;
    WithdrawRequest[] withdrawRequests;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        Input memory input = abi.decode(
            jsonData.parseRaw(_testDataKey), 
            (Input)
        );

        approvedRequestId = input.approvedRequestId;
        numMembers = input.numMembers;
        for (uint256 i = 0; i < input.withdrawRequests.length; i++) {
            withdrawRequests.push(input.withdrawRequests[i]);
        }

        creator = makeAddr("creator");

        address userBase = makeAddr("user");
        for (uint160 i = 0; i < numMembers + 1; i++) {
            users.push(address(uint160(userBase) + i));
        }
    }

    function setUp() public {
        totalAmulets = 0;
        vm.prank(creator);
        amulet = IMintable(address(new Amulet()));
        
        amuletPouch = IAmuletPouch(address(new AmuletPouch(address(amulet))));
    }

    // Helper function to deposit an Amulet (for non-members)
    function depositAmulet(address _owner) private {
        vm.prank(creator);
        amulet.mint(_owner, "https://url.com");

        vm.prank(_owner);
        amulet.safeTransferFrom(
            _owner, 
            address(amuletPouch), 
            totalAmulets++, 
            ""
        );
    }

    // Helper function to deposit an Amulet and request withdrawal of another
    function exchangeAmulet(address _owner, uint256 _withdrawId) private {
        vm.prank(creator);
        amulet.mint(_owner, "https://url.com");

        vm.prank(_owner);
        amulet.safeTransferFrom(
            _owner, 
            address(amuletPouch), 
            totalAmulets++, 
            abi.encode(_withdrawId)
        );
    }

    function test_receive_Amulets_and_register_members() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
            assertTrue(amuletPouch.isMember(users[i]));
        }

        assertEq(amuletPouch.totalMembers(), numMembers);
    }

    function test_reject_other_erc721_tokens() external {
        vm.startPrank(creator);
        IMintable amulet2 = IMintable(address(new Amulet()));

        amulet2.mint(users[0], "https://url.com");

        vm.stopPrank();

        vm.prank(users[0]);
        vm.expectRevert();
        amulet2.safeTransferFrom(
            users[0], 
            address(amuletPouch), 
            0
        );
    }

    function test_register_request_to_withdraw_Amulets() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        for (uint256 i = 0; i < withdrawRequests.length; i++) {
            WithdrawRequest memory request = withdrawRequests[i];
            address requester = users[request.requesterId];

            vm.prank(creator);
            amulet.mint(requester, "https://url.com");

            vm.expectEmit();
            emit WithdrawRequested(requester, request.withdrawalId, i);
            vm.prank(requester);
            amulet.safeTransferFrom(
                requester, 
                address(amuletPouch), 
                totalAmulets++, 
                abi.encode(request.withdrawalId)
            );

            (address actualRequester, uint256 actualTokenId) = amuletPouch.withdrawRequest(i);
            assertEq(actualRequester, requester);
            assertEq(actualTokenId, request.withdrawalId);

            assertEq(amuletPouch.numVotes(i), 1);
        }
    }

    function test_reject_withdrawal_of_Amulets_with_insufficient_votes() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        for (uint256 i = 0; i < withdrawRequests.length; i++) {
            WithdrawRequest memory request = withdrawRequests[i];
            address requester = users[request.requesterId];
            exchangeAmulet(requester, request.withdrawalId);

            vm.prank(requester);
            vm.expectRevert();
            amuletPouch.withdraw(i);
        }

    }

    function test_withdraw_Amulets_with_enough_votes() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        for (uint256 i = 0; i < withdrawRequests.length; i++) {
            WithdrawRequest memory request = withdrawRequests[i];
            address requester = users[request.requesterId];
            exchangeAmulet(requester, request.withdrawalId);
        }

        // Vote for some withdraw request
        uint256 requesterId = withdrawRequests[approvedRequestId].requesterId;
        uint256 numVotes = 1;
        for (uint256 i = 0; numVotes <= numMembers / 2; i++) {
            if (i == requesterId) { continue; }

            vm.prank(users[i]);
            amuletPouch.voteFor(approvedRequestId);

            numVotes++;
        }
        
        // Voted withdrawal should be authorized. Other withdrawals should still revert.
        for (uint256 i = 0; i < withdrawRequests.length; i++) {
            WithdrawRequest memory request = withdrawRequests[i];
            address requester = users[request.requesterId];
            
            uint256 expectedNumVotes = (i == approvedRequestId)
                ? numVotes : 1;

            assertEq(amuletPouch.numVotes(i), expectedNumVotes);

            vm.prank(requester);

            if (i == approvedRequestId) {
                amuletPouch.withdraw(i);
                assertEq(amulet.ownerOf(request.withdrawalId), requester);
            } else {
                vm.expectRevert();
                amuletPouch.withdraw(i);
            }

        }

    }

    function test_reject_withdrawal_from_unauthorized_caller() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        WithdrawRequest memory request = withdrawRequests[approvedRequestId];
        address requester = users[request.requesterId];

        exchangeAmulet(requester, request.withdrawalId);

        // Vote for some withdraw request
        uint256 requesterId = withdrawRequests[approvedRequestId].requesterId;
        uint256 numVotes = 1;
        for (uint256 i = 0; numVotes <= numMembers / 2; i++) {
            if (i == requesterId) { continue; }

            vm.prank(users[i]);
            amuletPouch.voteFor(0);

            numVotes++;
        }

        // Should revert since users[0] is not requester
        vm.expectRevert();
        vm.prank(users[0]);
        amuletPouch.withdraw(0);
    }

    function test_reject_vote_from_a_nonMember() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        WithdrawRequest memory request = withdrawRequests[0];
        address requester = users[request.requesterId];

        exchangeAmulet(requester, request.withdrawalId);

        address nonMember = users[numMembers];
        vm.prank(nonMember);
        vm.expectRevert();
        amuletPouch.voteFor(0);

    }

    function test_reject_duplicate_vote() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        WithdrawRequest memory request = withdrawRequests[0];
        address requester = users[request.requesterId];

        exchangeAmulet(requester, request.withdrawalId);

        vm.startPrank(users[0]);
        amuletPouch.voteFor(0);
        vm.expectRevert();
        amuletPouch.voteFor(0); // Duplicate vote
    }

    function test_reject_vote_for_an_inexistent_request() external {
        for (uint256 i = 0; i < numMembers; i++) {
            depositAmulet(users[i]);
        }

        for (uint256 i = 0; i < withdrawRequests.length; i++) {
            WithdrawRequest memory request = withdrawRequests[i];
            address requester = users[request.requesterId];
            exchangeAmulet(requester, request.withdrawalId);
        }

        // Should revert since requestId does not exist
        vm.prank(users[0]);
        vm.expectRevert();
        amuletPouch.voteFor(withdrawRequests.length);
    }


}
