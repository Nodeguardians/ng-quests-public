// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./utils/Decimal.sol";

contract ProposalHandler {
    using Decimal for Decimal.D256;

    uint internal constant VOTING_PERIOD = 10_000 days;
    uint internal constant EMERGENCY_PERIOD = 1 minutes;
    ERC20 public immutable GOV_TOKEN;

    enum ProposalStatus {
        Active,
        Closed,
        Passed
    }

    struct AccountState {
        uint256 votedUntil;
        uint256 power;
    }
    
    struct Proposal {
        bool executed;
        uint128 timestamp;
        uint256 power;
        address target;
        bytes targetData;
    }

    uint32 internal proposalIndex;
    mapping(uint32 => mapping(address => bool)) public voted;
    mapping(uint32 => Proposal) public proposals;
    mapping(address => AccountState) public accounts;

    constructor(address _govToken) { GOV_TOKEN = ERC20(_govToken); }

    function powerFor(uint32 proposalId) public view returns (uint256) {
        return proposals[proposalId].power;
    }
    
    function totalPower() public view returns (uint256) {
        return GOV_TOKEN.totalSupply();
    }

    function proposalVotePercent(
        uint32 proposalId
    ) public view returns (Decimal.D256 memory) {
        return Decimal.ratio(powerFor(proposalId), totalPower());
    }

    function status(
        uint32 proposalId
    ) public view returns (ProposalStatus) {
        Proposal memory proposal = proposals[proposalId];

        require(proposal.timestamp > 0, "Proposal doesn't exist");

        if (proposal.executed) {
            return ProposalStatus.Passed;
        } 

        uint256 endTime = proposal.timestamp + VOTING_PERIOD;
        
        if (block.timestamp < endTime) {
            return ProposalStatus.Active;
        } else {
            return ProposalStatus.Closed;
        }

    }

    function _createProposal(
        address target, 
        bytes memory targetData
    ) internal returns (uint32) {
        uint32 proposalId = proposalIndex;
        proposals[proposalIndex] = Proposal ({
            executed: false,
            timestamp: uint128(block.timestamp),
            power: 0,
            target: target,
            targetData: targetData
        });

        proposalIndex += 1;
        return proposalId;
    }

    function hasMajority(
        uint32 proposalId
    ) internal view returns (bool) {
        return proposalVotePercent(proposalId)
            .greaterThanOrEqualTo(Decimal.ratio(1, 2));
    }

    function hasSupermajority(
        uint32 proposalId
    ) internal view returns (bool) {
        return proposalVotePercent(proposalId)
            .greaterThanOrEqualTo(Decimal.ratio(2, 3));
    }   
}
