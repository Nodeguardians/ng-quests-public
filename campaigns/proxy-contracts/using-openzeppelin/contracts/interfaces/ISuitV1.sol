// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISuitV1 {

    /**
     * @dev Initializer called by the upgradeable proxy. Can only be called once.
     * @param _threshold Energy requirement for suit to fire its laser cannon.
     */
    function initialize(uint256 _threshold) external;

    /**
     * @dev Returns total energy offered by `source` to the contract (in wei).
     */
    function energy(address source) external view returns (uint256);

    /**
     * @dev Returns total energy of suit (in wei).
     * Initially 0 after contract initialization.
     */
    function totalEnergy() external view returns (uint256);

    /**
     * @dev If total energy > threshold, returns `keccak256("KSHAAAKKKKKK!!!")`. 
     * Else, the function fails.
     */
    function fireLaser() external view returns (bytes32);

    /**
     * @dev Called by a source to give the suit energy.
     * Adds `msg.value` to total energy.
     */
    function offerPower() external payable;

}