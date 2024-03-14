// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC721TokenReceiver.sol";

interface IAmuletPouch is IERC721TokenReceiver {

    /**
     * @dev This emits when a withdrawal is requester by a member that has deposited a new Amulet into the pouch. 
     */
    event WithdrawRequested(address indexed requester, uint256 indexed tokenId, uint256 indexed requestId);

    /**
     * @dev Returns whether `_user` is a member of the pouch.
     */
    function isMember(address _user) external view returns (bool);

    /**
     * @dev Returns the total number of members of the pouch.
     */
    function totalMembers() external view returns (uint256);

    /**
     * @dev Returns the address of the requester and the token ID they wish to withdraw for a given `_requestId`.
     */
    function withdrawRequest(uint256  _requestId) external view returns (address, uint256);

    /**
     * @dev Returns the number of votes for a given `_requestId`. 
     */
    function numVotes(uint256  _requestId) external view returns (uint256);

    /**
     * @dev Registers the caller's approval of the withdraw request
     * given by `_requestId`.
     * Reverts:
     *      - If the caller is not an existing pouch member
     *      - If the caller has already voted for the given request
     *      _ Or if the request does not exist
     */
    function voteFor(uint256 _requestId) external;

    /**
     * @dev Processes the withdraw request given by `_requestId`, transferring the relevant Amulet to `msg.sender`.
     * Reverts:
     *      - If the request has not received majority vote
     *      - If `msg.sender` is not the requester associated to `_requestId`
     *      - Or if the request does not exist
     */
    function withdraw(uint256 _requestId) external;

    /**
     * @dev If `_from` is not a member, adds them to the list of members.
     * Else, if `_data.length > 0`, register the request for `_from` 
     * to withdraw the Amulet with ID given by `_data` and emits a {WithdrawRequested} event.
     * The pouch does not accept other ERC721 token other than Amulets!
     * @return Selector for onERC721Received (i.e., `0x150b7a02`).
     */
    function onERC721Received(
        address /* _operator */,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external returns (bytes4);
}