// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IVillageFunding {    
    /**
     * @dev Returns the project IDs
     */
    function getProjects() external view returns (uint256[] memory);

    /**
     * @dev Returns the vote power of a villager
     * @param villager - the address of a villager
     */
    function getVotePower(address villager) external view returns (uint256);

    /**
     * @dev Returns the amount of contributed vote power 
     * and the number of unique contributors to a certain project
     * @param projectId - the ID of the project
     * @return contributions - the sum of all vote powers 
     * contributed to the project
     * @return numberOfPeople - the number of unique people 
     * that voted for the project
     */
    function getContributions(uint256 projectId) 
        external 
        view 
        returns (uint256 contributions, uint256 numberOfPeople);

    /**
     * @dev Returns the final amount of funds for a certain project
     * @param projectId - the ID of the project
     */
    function getFunds(uint256 projectId) external view returns (uint256);
    
    /**
     * @dev Call to donate ETH to get a certain amount of vote power
     * Can only be called once per villager and before voting ends
     */
    function donate() external payable;

    /**
     * @dev Call to vote for a certain project
     * Should revert if a villager tries to vote with 0 vote power
     * @param projectId - the ID of the project to vote on
     * @param votePower - the amount of vote power to vote with
     */
    function vote(uint256 projectId, uint256 votePower) external;

    /**
     * @dev Called by a deployer to distrbute funds
     */
    function distribute() external;
}
