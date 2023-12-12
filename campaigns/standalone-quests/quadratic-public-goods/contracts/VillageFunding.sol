// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IVillageFunding.sol";

contract VillageFunding is IVillageFunding {

    constructor(
        address[] memory _villagers, 
        uint256[] memory _projectIds,
        uint256 _voteDuration
    ) payable {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function donate() external payable {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function vote(uint256 _projectId, uint256 _votePower) external {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function distribute() external {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function getProjects() external view returns (uint256[] memory) {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function getVotePower(address _villager) external view returns (uint256) {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function getContributions(uint256 _projectId) 
        external 
        view 
        returns (uint256, uint256) 
    {
        // YOUR CODE HERE
    }

    /**
     * @inheritdoc IVillageFunding
     */
    function getFunds(uint256 _projectId) external view returns (uint256) {
        // YOUR CODE HERE
    }
}
