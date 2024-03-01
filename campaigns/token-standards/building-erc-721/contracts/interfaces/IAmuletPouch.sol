// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC721TokenReceiver.sol";

interface IAmuletPouch is IERC721TokenReceiver {

    /**
     * @dev Returns whether `_user` is a member of the pouch.
     */
    function isMember(address _user) external view returns (bool);

    /**
     * @dev Returns the total number of members of the pouch.
     */
    function totalMembers() external view returns (uint256);

    /**
     * @dev Returns whether `_requester` has a pending request to
     * withdraw an Amulet with `_tokenId` in the pouch.
     */
    function isWithdrawRequest(address _requester, uint256 _tokenId) external view returns (bool);

    /**
     * @dev Returns the number of votes for `_requester` to withdraw 
     * the Amulet with `_tokenId`.
     * Returns 0 if no such pending request exists.
     */
    function numVotes(address _requester, uint256 _tokenId) external view returns (uint256);

    /**
     * @dev Registers the caller's approval of `_requester` to withdraw 
     * the Amulet with `_tokenId`. The caller must be an existing pouch member.
     * Reverts if there is no pending request for `_requester` to withdraw 
     * the Amulet with `_tokenId`.
     */
    function voteFor(address _requester, uint256 _tokenId) external;

    /**
     * @dev Transfers an Amulet with `_tokenId` to address `msg.sender`. 
     * Reverts if the withdrawal is not approved by the majority of pouch members.
     * If successful, remove `msg.sender` from the list of members 
     * and all pending requests belonging to them.
     */
    function withdraw(uint256 _tokenId) external;

    /**
     * @dev If `_from` is not a member, adds them to the list of members.
     * Else, if `_data.length > 0`, register the request for `_from` 
     * to withdraw the Amulet with `_tokenId`.
     * @return Selector for onERC721Received (i.e., `0x150b7a02`).
     */
    function onERC721Received(
        address /* _operator */,
        address _from,
        uint256 _tokenId,
        bytes memory _data
    ) external returns (bytes4);
}