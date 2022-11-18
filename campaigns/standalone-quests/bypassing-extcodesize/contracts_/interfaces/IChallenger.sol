// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

interface IChallenger {

    /// @notice Called by Basilisk. Should return true.
    function challenge() external pure returns (bool);

}