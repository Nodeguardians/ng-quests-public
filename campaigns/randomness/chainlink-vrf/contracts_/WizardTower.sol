// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { VRFConsumerBaseV2Plus } 
    from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import { VRFV2PlusClient } 
    from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract WizardTower is VRFConsumerBaseV2Plus {

    address private constant COORDINATOR = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    
    uint32 public floorsClimbed;

    constructor() VRFConsumerBaseV2Plus(COORDINATOR) { }

    function climb(
        bytes32 step1,
        uint256 step2,
        uint16 step3,
        uint32 step4,
        uint32 step5
    ) external {
        s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: step1,
                subId: step2,
                requestConfirmations: step3,
                callbackGasLimit: step4,
                numWords: step5,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1( {nativePayment: true} )
                )
            })
        );
    }

    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] calldata randomWords
    ) internal override {
        floorsClimbed = uint32(randomWords.length);
    }

}