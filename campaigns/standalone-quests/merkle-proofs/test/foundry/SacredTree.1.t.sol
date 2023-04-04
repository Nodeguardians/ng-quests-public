// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../contracts/SacredTree.sol";

contract PublicTest1 is Test {

    bytes32 constant ROOT_HASH = 0xbd150162dead740efc1f898cae744c69ccf898415b98d8c95e9ae7116361796c;
    function test_correct_root() external {
        SacredTree tree = new SacredTree();
        bytes32 root = tree.root();

        assertEq(keccak256(abi.encode(root)), ROOT_HASH, "Incorrect root");
    }

}
