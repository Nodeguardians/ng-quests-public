// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SimpleGameV1.sol";
import "./SimpleGameV2.sol";
import "./Attacker.sol";

contract TestProbe {

    // Attacker should work.
    function test1() external payable {
        SimpleGameV1 game = new SimpleGameV1();
        Attacker attacker = new Attacker();

        attacker.attack{value: 1 ether}(game);

        if (game.isFinished() == false) revert();
        if (address(attacker).balance != 1 ether) revert();
    }

    // V2 should receive unexpected ether safely.
    function test2() external payable {
        SimpleGameV2 game = new SimpleGameV2();

        game.deposit{ value: 0.1 ether }();
        new A{ value: 0.9 ether }(address(game));

        require(game.totalDeposit() == 0.1 ether);
        
        try game.claim() {
            revert();
        } catch { }
    }

}

contract A {

    constructor(address target) payable {
        selfdestruct(payable(target));
    }

}
