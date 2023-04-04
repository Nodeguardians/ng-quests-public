// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/Attacker.sol";
import "../../contracts/SimpleGameV2.sol";

contract PublicTest1 is Test {

    address constant PLAYER = 0xC11d240cce2Db476907c8AD07695A2E7FD33e8b5;
    SimpleGameV2 game;
    Attacker attacker;

    function setUp() external{
        game = new SimpleGameV2();
        attacker = new Attacker();

        startHoax(PLAYER);
    }

    function test_immune_to_attacker() external {

        for (uint256 i = 0; i < 5; i++) {
            game.deposit{ value: 0.1 ether }();
            vm.roll(block.number + 1);
        }

        vm.expectRevert("Condition not satisfied");
        attacker.attack{ value: 0.5 ether }(SimpleGameV1(address(game)));

    }

    function test_only_accept_fixed_ETH_amount_each_deposit() external {
        vm.expectRevert();
        game.deposit{ value: 0.2 ether }();

        game.deposit{ value: 0.1 ether }();
    }

    function test_not_claimable_before_condition_satisfied() external {
        for (uint256 i = 0; i < 9; i++) {
            game.deposit{ value: 0.1 ether }();
            vm.roll(block.number + 1);
        }

        vm.expectRevert("Condition not satisfied");
        game.claim();

        game.deposit{ value: 0.1 ether }();
        game.claim();
    }

    function test_finish_the_game_after_claimed() external {
        for (uint256 i = 0; i < 10; i++) {
            game.deposit{ value: 0.1 ether }();
            vm.roll(block.number + 1);
        }

        game.claim();
        assertTrue(game.isFinished(), "Game not finished");

        vm.expectRevert("The game is over");
        game.deposit{ value: 0.1 ether }();
    }

}