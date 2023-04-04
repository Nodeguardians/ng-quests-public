// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/UpgradeableMechSuit.sol";
import "../../contracts/MechSuitV1.sol";
import "../../contracts/MechSuitV2.sol";

contract PublicTest1 is Test {

    address public suitLogic;
    UpgradeableMechSuit public suit;

    bytes32 constant IMPL_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;


    constructor() {
        suitLogic = address(new MechSuitV1());
        suit = new UpgradeableMechSuit(suitLogic);
    }

    function test_EIP1967_compliance() external {
        address impl = _loadAddress(address(suit), IMPL_SLOT);
        assertEq(impl, suitLogic, "Bad implementation slot");

        address admin = _loadAddress(address(suit), ADMIN_SLOT);
        assertEq(admin, address(this), "Bad admin slot"); 
    }

    function test_only_allow_admin_to_call_UpgradeTo() external {
        address notAdmin = address(0xb00b00b00);
        address newLogic = address(new MechSuitV2());
        hoax(notAdmin);
        vm.expectRevert();
        suit.upgradeTo(newLogic);
    }

    function _loadAddress(
        address _target, 
        bytes32 _slot
    ) private view returns (address) {
        bytes32 slotValue = vm.load(_target, _slot);
        return address(uint160(uint256(slotValue)));
    }

}