//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {
    DEPLOYER_SYSTEM_CONTRACT,
    IContractDeployer
} from "@matterlabs/zksync-contracts/l2/system-contracts/Constants.sol";
import "@matterlabs/zksync-contracts/l2/system-contracts/libraries/SystemContractHelper.sol";

contract Lungs {

    address public lastRoar;

    function roar(bytes32 _bytecodeHash) external {
        // TODO: Implement this function
    }

}
