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
    using stdJson for string;

    struct WithdrawRequests {
        uint256 requesterId;
        uint256[] withdrawalIds;
    }

    struct Input {
        uint256 numMembers;
        WithdrawRequests withdrawRequests;
    }

    IMintable amulet;
    IAmuletPouch amuletPouch;

    address creator;
    address[] users;

    Input input;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);
        input = abi.decode(
            jsonData.parseRaw(_testDataKey), 
            (Input)
        );

        creator = makeAddr("creator");

        address userBase = makeAddr("user");
        for (uint160 i = 0; i < input.numMembers + 1; i++) {
            users.push(address(uint160(userBase) + i));
        }
    }

    function setUp() public {

        vm.prank(creator);
        amulet = IMintable(address(new Amulet()));
        for (uint i = 0; i < input.numMembers; i++) {
            mintAmulet(users[i], i);
        }
        
        amuletPouch = IAmuletPouch(address(new AmuletPouch(address(amulet))));

    }

    // Helper function to mint Amulets
    function mintAmulet(address _owner, uint256) private {
        vm.prank(creator);
        amulet.mint(_owner, "https://url.com");
    }

    // Helper function to deposit an Amulet (for non-members)
    function depositAmulet(address _owner, uint256 _tokenId) private {
        vm.prank(_owner);
        amulet.safeTransferFrom(
            _owner, 
            address(amuletPouch), 
            _tokenId, 
            ""
        );
    }

    // Helper function to deposit an Amulet and request withdrawal of another
    function exchangeAmulet(address _owner, uint256 _depositId, uint256 _withdrawId) private {
        vm.prank(_owner);
        amulet.safeTransferFrom(
            _owner, 
            address(amuletPouch), 
            _depositId, 
            abi.encode(_withdrawId)
        );
    }

    // Helper function to for majority of members to vote for a withdrawal
    function voteForWithdrawal(
        address _requester, 
        uint256 _withdrawalId
    ) private returns (uint256) {
        uint256 voteCount = 1;
        for (uint256 i = 0; voteCount <= input.numMembers / 2; i++) {
            if (i == input.withdrawRequests.requesterId) {
                continue;
            }

            vm.prank(users[i]);
            amuletPouch.voteFor(_requester, _withdrawalId);
            voteCount++;
        }

        return voteCount;
    }

    function test_receive_Amulets_and_register_members() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
            assertTrue(amuletPouch.isMember(users[i]));
        }

        assertEq(amuletPouch.totalMembers(), input.numMembers);
    }

    function test_reject_other_erc721_tokens() external {
        vm.startPrank(creator);
        Amulet amulet2 = new Amulet();

        amulet2.mint(users[0], "https://url.com");

        vm.stopPrank();

        vm.prank(users[0]);
        vm.expectRevert();
        amulet2.safeTransferFrom(
            users[0], 
            address(amuletPouch), 
            1, 
            ""
        );
    }

    function test_register_request_to_withdraw_Amulets() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 depositId = input.numMembers;
        uint256[] memory withdrawalIds = input.withdrawRequests.withdrawalIds;

        for (uint256 i = 0; i < withdrawalIds.length; i++) {
            mintAmulet(requester, depositId + i);
            exchangeAmulet(requester, depositId + i, withdrawalIds[i]);

            assertTrue(
                amuletPouch.isWithdrawRequest(
                    requester, 
                    withdrawalIds[i]
                )
            );
            assertEq(
                amuletPouch.numVotes(
                    requester, 
                    withdrawalIds[i]
                ), 
                1
            );
        }
    }

    function test_reject_withdrawal_of_Amulets_with_insufficient_votes() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 depositId = input.numMembers;
        uint256 withdrawalId = input.withdrawRequests.withdrawalIds[0];

        vm.prank(requester);
        vm.expectRevert();
        amuletPouch.withdraw(withdrawalId);

        mintAmulet(requester, depositId);
        exchangeAmulet(requester, depositId, withdrawalId);

        vm.prank(requester);
        vm.expectRevert();
        amuletPouch.withdraw(withdrawalId);

    }

    function test_withdraw_Amulets_with_enough_votes() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 depositId = input.numMembers;
        uint256 withdrawalId = input.withdrawRequests.withdrawalIds[0];

        mintAmulet(requester, depositId);
        exchangeAmulet(requester, depositId, withdrawalId);

        uint256 voteCount = voteForWithdrawal(requester, withdrawalId);

        assertEq(
            amuletPouch.numVotes(requester, withdrawalId), 
            voteCount
        );
        vm.prank(requester);
        amuletPouch.withdraw(withdrawalId);

        assertEq(amulet.ownerOf(withdrawalId), requester);
    }

    function test_revoke_membership_and_requests_after_withdrawing_Amulet() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 depositId = input.numMembers;
        uint256[] memory withdrawalIds = input.withdrawRequests.withdrawalIds;

        for (uint256 i = 0; i < withdrawalIds.length; i++) {
            mintAmulet(requester, depositId + i);
            exchangeAmulet(requester, depositId + i, withdrawalIds[i]);
        }

        voteForWithdrawal(requester, withdrawalIds[0]);

        vm.prank(requester);
        amuletPouch.withdraw(withdrawalIds[0]);

        assertFalse(amuletPouch.isMember(requester));
        for (uint256 i = 0; i < withdrawalIds.length; i++) {
            assertFalse(
                amuletPouch.isWithdrawRequest(requester, withdrawalIds[i])
            );
        }

    }

    function test_reject_vote_for_an_inexistent_request() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 withdrawalId = input.withdrawRequests.withdrawalIds[0];

        vm.prank(users[0]);
        vm.expectRevert();
        amuletPouch.voteFor(requester, withdrawalId);
    }

    function test_reject_vote_from_a_nonMember() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 depositId = input.numMembers;
        uint256 withdrawalId = input.withdrawRequests.withdrawalIds[0];

        mintAmulet(requester, depositId);
        exchangeAmulet(requester, depositId, withdrawalId);

        vm.prank(users[input.numMembers]);
        vm.expectRevert();
        amuletPouch.voteFor(requester, withdrawalId);
    }

    function test_allow_user_to_reRegister_as_member_after_withdrawal() external {
        for (uint256 i = 0; i < input.numMembers; i++) {
            depositAmulet(users[i], i);
        }

        address requester = users[input.withdrawRequests.requesterId];
        uint256 depositId = input.numMembers;
        uint256[] memory withdrawalIds = input.withdrawRequests.withdrawalIds;

        mintAmulet(requester, depositId);
        exchangeAmulet(requester, depositId, withdrawalIds[0]);

        voteForWithdrawal(requester, withdrawalIds[0]);

        vm.prank(requester);
        amuletPouch.withdraw(withdrawalIds[0]);

        mintAmulet(requester, depositId + 1);
        depositAmulet(requester, depositId + 1);

        // Requester should re-register as member.
        assertTrue(amuletPouch.isMember(requester));

        // Previously pending requests should still remain deleted.
        assertFalse(
            amuletPouch.isWithdrawRequest(requester, withdrawalIds[0])
        );
        assertEq(
            amuletPouch.numVotes(requester, withdrawalIds[0]), 
            0
        );
        
        // New requests should be registered.
        exchangeAmulet(requester, withdrawalIds[0], withdrawalIds[1]);
        assertTrue(
            amuletPouch.isWithdrawRequest(requester, withdrawalIds[1])
        );
        assertEq(
            amuletPouch.numVotes(requester, withdrawalIds[1]), 
            1
        );


    }

}
