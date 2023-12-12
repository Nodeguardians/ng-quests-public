// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IVillageVoting.sol";

contract VillageVoting is IVillageVoting {
    /**
     * @inheritdoc IVillageVoting
     */
    mapping (address => uint256) public balanceOf;
    
    constructor(
        address[] memory _villagers, 
        uint256[] memory _voteTokens, 
        uint256[] memory _proposalIds,
        uint256 _roundDuration
    ) payable {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageVoting
     */
    function vote(
        uint256[] calldata _proposalIds, 
        uint256[] calldata _amounts
    ) external {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageVoting
     */
    function countVotes() external {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageVoting
     */
    function getActiveProposals() external view returns (uint256[] memory) {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageVoting
     */
    function getRoundInfo() external view returns (uint256, uint256, uint256) {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageVoting
     */
    function getProposalVotePower(uint256 _proposalId, uint256 _round) 
        external 
        view 
        returns (uint256) 
    {
        // YOUR CODE HERE
    }
}
