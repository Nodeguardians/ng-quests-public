// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/Attacker.sol";
import "../../contracts/SimpleGameV1.sol";

contract PublicTest1 is Test {

    SimpleGameV1 game;
    Attacker attacker;

    function setUp() external{
        game = new SimpleGameV1();
        attacker = new Attacker();
    }

    function test_win_SimpleGame_with_attack() external {

        for (uint256 i = 0; i < 5; i++) {
            game.deposit{ value: 0.1 ether }();
            vm.roll(block.number + 1);
        }

        attacker.attack{ value: 0.5 ether }(game);
        assertEq(address(attacker).balance, 1 ether, "Attack failed");

    }

}