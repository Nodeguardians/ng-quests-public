// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Chess pieces:
// ♔, ♕, ♖, ♗, ♘, ♙, ♚, ♛, ♜, ♝, ♞, ♟
// Board characters:
// |, ■, □, \n

contract Challenge {
    /**
     * @dev Record a board with a given id.
     * @param id  The id of the board.
     * @param board  The board to record as a string containing UTF-8 characters.
     */
    function recordBoard(bytes32 id, string calldata board) external {}

    /**
     * @dev Get a board with a given id.
     * @param id The id of the board to get.
     * @return board  The board as a string containing UTF-8 characters.
     */
    function getBoard(bytes32 id) external view returns (string memory board) {}
}
