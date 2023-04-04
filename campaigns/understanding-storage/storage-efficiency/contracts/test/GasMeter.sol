// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Elegy1.sol";
import "../Elegy2.sol";

contract GasMeter {

    function measureSetVerse(
        bytes8 _firstVerse,
        bytes32 _secondVerse,
        address _thirdVerse,
        uint128 _fourthVerse,
        uint96 _fifthVerse 
    ) external returns (uint256) {
        Elegy1 elegy = new Elegy1();
        uint256 initGas = gasleft();
        elegy.setVerse(
            _firstVerse,
            _secondVerse,
            _thirdVerse,
            _fourthVerse,
            _fifthVerse
        );
        uint256 gasSpent = initGas - gasleft();

        return gasSpent;
    } 

    function measurePlay(
        uint32[] memory _lines,
        uint256 _nonce
    ) external returns (uint256) {
        Elegy2 elegy = new Elegy2(_lines);
        uint256 initGas = gasleft();
        elegy.play(_nonce);
        uint256 gasSpent = initGas - gasleft();

        return gasSpent;
    }

}