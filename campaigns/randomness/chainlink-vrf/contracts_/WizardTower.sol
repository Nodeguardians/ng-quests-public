// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

contract WizardTower is VRFConsumerBaseV2 {

    address private constant COORDINATOR = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    
    uint32 public floorsClimbed;

    constructor() VRFConsumerBaseV2(COORDINATOR) { }

    function climb(
        bytes32 step1,
        uint64 step2,
        uint16 step3,
        uint32 step4,
        uint32 step5
    ) external {
        VRFCoordinatorV2Interface(COORDINATOR).requestRandomWords(
            step1,
            step2,
            step3,
            step4,
            step5
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        floorsClimbed = uint32(randomWords.length);
    }

}