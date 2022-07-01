// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./MechSuitV1.sol";
import "./MechSuitV2.sol";
import "./UpgradeableMechSuit.sol";

contract TestProbe {

    address payable public suit;
    address public impl;

    constructor() {
        impl = address(new MechSuitV1());
        suit = payable(address(new UpgradeableMechSuit(impl)));
    }

    function test1() external payable {
        require(msg.value == 1 gwei);

        MechSuitV1 v1 = MechSuitV1(suit);

        // Existent functionality should work
        v1.refuel{value: 1 gwei}();
        require(
            v1.swingHammer() == keccak256("HAMMER SMASH!!!")
        );
        require(v1.fuel() == 90);

        // Inexistent functionality should fail
        try MechSuitV2(suit).blastCannon() {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }

    }

    function test2() external payable {
        impl = address(new MechSuitV2());
        UpgradeableMechSuit(suit).upgradeTo(impl);

        MechSuitV2 v2 = MechSuitV2(suit);

        // New functionality should work
        v2.refuel{value: 1 gwei}();
        require(
            v2.blastCannon() == keccak256("BOOM!")
        );
        require(v2.ammunition() == 7);

        // Old functionality should fail
        try MechSuitV1(suit).swingHammer() {
            revert();
        } catch (bytes memory) {
            // Do nothing
        }
    }

    function test3() external {
        new NotAdmin(suit);
    }

}

contract NotAdmin {

    constructor(address payable suit) {
        UpgradeableMechSuit(suit).upgradeTo(
            address(new MechSuitV1())
        );
    }
    
}