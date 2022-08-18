// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISuitV2 {

    /**
     * @dev Returns total energy offered by `source` to the contract (in wei) since last fired laser cannon.
     */
    function energy(address source) external view returns (uint256);

    /**
     * @dev Returns total energy of suit (in wei).
     */
    function totalEnergy() external view returns (uint256);

    /**
     * @dev Called by a source to give the suit energy.
     * Adds `msg.value` to total energy.
     */
    function offerPower() external payable;

    /**
     * @dev If energy(`msg.sender`) > 0, transfer the energy (in wei) back to `msg.sender`. 
     * Fails otherwise. 
     */
    function withdrawPower() external;

    /**
     * @dev If total energy > threshold, resets total energy back to 0 and returns `keccak256("KSHAAAKKKKKK!!!")`.
     * Else, the function fails.
     */
    function fireLaser() external returns (bytes32);
}