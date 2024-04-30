// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { SharesProof } from "../types/BlobstreamTypes.sol";

interface IObservatory {

    function isProven() external view returns (bool);

    function proveComet(
        SharesProof calldata _proof, 
        bytes32 _root
    ) external view;

}