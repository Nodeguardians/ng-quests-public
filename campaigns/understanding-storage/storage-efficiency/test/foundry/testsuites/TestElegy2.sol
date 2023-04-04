// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/Elegy2.sol";
import "../../../contracts/test/GasMeter.sol";
import "forge-std/Test.sol";

abstract contract TestElegy2 is Test {

    using stdJson for string;

    struct Song {
        uint256 gasLimit;
        uint32[] lines;
        uint256 nonce;
    }

    Song song;
    uint256 totalSum;
    Elegy2 elegy;

    constructor(
        string memory _testDataPath, 
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);

        bytes memory rawSong = jsonData.parseRaw(_testDataKey);
        song = abi.decode(rawSong, (Song));

        elegy = new Elegy2(song.lines);

        for(uint i = 0; i < song.lines.length; i++) {
            totalSum += (i * song.nonce) * song.lines[i];
        }
    }

    function test_play() external {
        elegy.play(song.nonce);
        assertEq(elegy.totalSum(), totalSum, "Incorrect Result");
    }

    function test_play_efficiency() external {
        GasMeter gasMeter = new GasMeter();
        uint256 gasSpent = gasMeter.measurePlay(
            song.lines,
            song.nonce
        );

        assertLt(gasSpent, song.gasLimit, "Too Gas Inefficient");
    }
}
