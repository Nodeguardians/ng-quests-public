// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IVillageVoting {

    /// @notice Returns the proposals IDs that users can vote on.
    function getProposals() external view returns (uint256[] memory);

    /// @notice Returns the winning proposal ID.
    /// Reverts if the winner has not yet been decided.
    function getWinningProposal() external view returns (uint256);

    /**
     * @notice Returns the amount of tokens held by the given villager
     * @param villager The address of a villager
     */
    function balanceOf(address villager) external view returns (uint256);

    /**
     * @notice Returns the sum of the vote power for a proposal with the given ID. 
     * @param proposalId The ID of the proposal
     */
    function votePower(uint256 proposalId) external view returns (uint256);

    /**
     * @notice Villagers call this function to vote for their preferred proposals. 
     * Proposals must exist and `msg.sender` must have a sufficient amount of tokens. 
     * Each villager can only vote once per round and before the voting round ends.
     * @param proposalIds Proposal IDs that a villager wants to vote for.
     * @param amounts Corresponding amounts of vote tokens for each proposal.
     * @dev If proposalIds contain inexistent proposals or duplicates, revert the function.
     */
    function vote(
        uint256[] calldata proposalIds,
        uint256[] calldata amounts
    ) external;
    
    /**
     * @dev Decides the winner.
     * This can only be called when the voting round ends.
     */
    function countVotes() external;
}
