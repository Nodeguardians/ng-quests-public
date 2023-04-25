// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./utils/Decimal.sol";
import "./ProposalHandler.sol";

contract Council is ProposalHandler {
    using Decimal for Decimal.D256;

    constructor(address _govToken) ProposalHandler(_govToken) {}

    function deposit(uint256 amount) external {
        require(GOV_TOKEN.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        accounts[msg.sender].power += amount;
    }

    function withdraw() external {
        AccountState memory account = accounts[msg.sender];

        require(account.power > 0, "Nothing to withdraw");
        require(account.votedUntil < block.timestamp, "Power locked in vote");
        require(GOV_TOKEN.transfer(msg.sender, account.power), "Transfer failed");
    }

    function propose(
        address target,
        bytes calldata targetData
    ) external returns (uint32) {
        require(target != address(0), "Proposition is empty");
        uint32 proposalId = _createProposal(target, targetData);

        return proposalId;
    }

    function vote(uint32 proposalId) external {
        require(status(proposalId) == ProposalStatus.Active, "Proposal not active");
        require(accounts[msg.sender].power > 0, "Voter must have power");
        require(!voted[proposalId][msg.sender], "Voter already voted");

        voted[proposalId][msg.sender] = true;
        proposals[proposalId].power += accounts[msg.sender].power;
        
        uint256 newLock = proposals[proposalId].timestamp + VOTING_PERIOD;
        if (newLock > accounts[msg.sender].votedUntil) {
            accounts[msg.sender].votedUntil = newLock;
        }
    }

    function execute(uint32 proposalId) external {
        require(status(proposalId) == ProposalStatus.Closed, "Proposal not closed");
        require(hasMajority(proposalId), "Must have majority");
        _execute(proposalId); 
    }

    function emergencyExecute(uint32 proposalId) external {
        require(status(proposalId) == ProposalStatus.Active, "Proposal not active");
        require(hasSupermajority(proposalId), "Must have supermajority");
        require(
            block.timestamp >= proposals[proposalId].timestamp + EMERGENCY_PERIOD, 
            "Too early for emergency execution"
        );
        
        _execute(proposalId);
    }

    function _execute(uint32 proposalId) private {
        (bool success, ) = proposals[proposalId].target.call(
            proposals[proposalId].targetData
        );
        require(success, "Execution failed");
        proposals[proposalId].executed = true;
    }

}