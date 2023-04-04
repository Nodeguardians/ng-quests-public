// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Elegy1.sol";
import "../../../contracts/test/GasMeter.sol";
import "forge-std/Test.sol";

abstract contract TestElegy1 is Test {

    using stdJson for string;

    bytes8 firstVerse;
    bytes32 secondVerse;
    address thirdVerse;
    uint128 fourthVerse;
    uint96 fifthVerse;

    constructor(string memory _testDataPath) {
        string memory jsonData = vm.readFile(_testDataPath);
        firstVerse = bytes8(jsonData.readBytes32(".firstVerse"));
        secondVerse = jsonData.readBytes32(".secondVerse");
        thirdVerse = jsonData.readAddress(".thirdVerse");
        fourthVerse = uint128(jsonData.readUint(".fourthVerse"));
        fifthVerse = uint96(jsonData.readUint(".fifthVerse"));
    }

    function test_set_verse() external {
        Elegy1 elegy = new Elegy1();
        elegy.setVerse(
            firstVerse,
            secondVerse,
            thirdVerse,
            fourthVerse,
            fifthVerse
        );

        assertTrue(
            elegy.firstVerse() == firstVerse
            && elegy.secondVerse() == secondVerse
            && elegy.thirdVerse() == thirdVerse
            && elegy.fourthVerse() == fourthVerse
            && elegy.fifthVerse() == fifthVerse,
            "Verses not set correctly"
        );

    }

    function test_set_verse_efficiency() external {
        GasMeter gasMeter = new GasMeter();

        uint256 gasSpent = gasMeter.measureSetVerse(
            firstVerse,
            secondVerse,
            thirdVerse,
            fourthVerse,
            fifthVerse
        );

        assertLt(gasSpent, 72000, "Too Gas Inefficient");
    }

}
