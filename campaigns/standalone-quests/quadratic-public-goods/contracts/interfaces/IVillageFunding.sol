// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IVillageFunding {

    /// @notice Returns the project addresses.
    function getProjects() external view returns (address[] memory);

    /// @notice The final amount of funds currently eligible to a given project.
    /// Returns 0 if funds are not finalized yet or if funds already claimed.
    function finalFunds(address _project) external returns (uint256);

    /// @notice A function that villagers call to donate ETH to a certain project. 
    /// Should be called before the contribution phase ends (7 days) and villagers can only donate to a specific project once.
    function donate(address _project) external payable;

    /// @notice Finalize funds raised by each project. 
    /// This is only callable after the contribution phase ends (7 days).
    function finalizeFunds() external;

    /// @notice Projects call this function to withdraw their raised funds. 
    /// If funds have not been finalized or `msg.sender` is not eligible to withdraw any funds.
    function withdraw() external;

}
