// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Interface for counting game.
 * @notice The rules of the game are as follows:
 * 1. Two players take turns loading ores into a mine cart.
 * 2. Each turn, they can load between 1 to 4 ores.
 * 3. If the total ores loaded onto the cart is a multiple of 5, 
 *    the cart spills a little, and two ores fall out.
 * 4. The first player to get the total ore count to above 20 wins.
 */
interface IMineCart {

    /// @notice Address of worker1, the worker who loads the cart every odd turn.
    function worker1() external returns (address payable);
    /// @notice Address of worker2, the worker who loads the cart every even turn.
    function worker2() external returns (address payable);

    /// @notice Total amount of ores already loaded onto the mine cart.
    function totalOres() external returns (uint256);
    /// @notice Current turn number. Starts at 1 (i.e., `worker1` starts the game).
    function messageNum() external returns (uint256);

    /// @notice Represents whether the channel is opened or closed.
    function isActive() external returns (bool);

    /**
     * @notice Update `totalOres` and `messageNum`.
     * `msg.sender` must be either worker, and `_signature` 
     * must be signed by the other worker. 
     * If `oresSold >= 21`, then the channel is closed and the
     * contract's funds is transferred to victor.
     * @param _totalOres New total amount of ores loaded onto cart.
     * @param _messageNum New turn number.
     */
    function update(
        uint256 _totalOres,
        uint256 _messageNum,
        bytes memory _signature
    ) external;

    /**
     * @notice Load `_newOres` into the cart. 
     * `msg.sender` must be the worker whose turn it is to 
     * load the cart and the move must follow the game's rules. 
     * If `oresSold >= 21`, then the channel is closed and the 
     * contract's funds are transferred to the victor.
     * @param _newOres Amount to ores to load onto cart.
     */
    function load(uint256 _newOres) external;

    /**
     * @notice If the current worker does not update the state in time, 
     * transfer all funds to the other worker and close the channel.
     */
    function timeOut() external;

}
