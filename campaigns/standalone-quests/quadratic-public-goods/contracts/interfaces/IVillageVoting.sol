// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IVillageVoting {
    /**
     * @dev Returns the proposals IDs 
     * that users can vote on in the current round.
     * Returns an empty array if the winner is decided.
     */
    function getActiveProposals() external view returns (uint256[] memory);

    /**
     * @dev Returns information about the current round
     * @param winner - the ID of the winner
     * @param round - the current round
     * @param roundEndTime - the end time of the current round in seconds
     */
    function getRoundInfo() 
        external 
        view 
        returns (uint256 winner, uint256 round, uint256 roundEndTime);

    /**
     * @dev Returns the amount of tokens held by the given villager
     * @param villager - the address of a villager
     */
    function balanceOf(address villager) external view returns (uint256);

    /**
     * @dev Returns the sum of the vote power contributed to 
     * a proposal with the given ID at the given round
     * @param proposalId - the ID of the proposal
     * @param round - the round number
     */
    function getProposalVotePower(uint256 proposalId, uint256 round) 
        external 
        view 
        returns (uint256);

    /**
     * @dev Villagers call this function to vote for their preferred proposals. 
     * Proposals must be active and the villager must have a sufficient 
     * amount of tokens. 
     * Each villager can only vote once per round and before the voting round ends.
     * @param proposalIds - array of proposal IDs that a villager wants to vote for
     * @param amounts - array of amounts of vote tokens for each proposal
     */
    function vote(uint256[] calldata proposalIds, uint256[] calldata amounts) external;
    
    /**
     * @dev Decides the winner or start a new voting round if there is a tie. 
     * This can only be called by the deployer and when the voting round ends.
     */
    function countVotes() external;
}
