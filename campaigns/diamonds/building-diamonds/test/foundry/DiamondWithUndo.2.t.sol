// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./utils/DiamondHelpers.sol";
import "./testsuites/TestUndo.sol";

contract PublicTest1 is Test {

    bytes4 immutable UNDO_SELECTOR = bytes4(keccak256(abi.encodePacked("undo()")));
    function test_have_undo_in_loupe() external {
        address diamondAddress = DiamondHelpers.deploy();

        address undoAddress = IDiamondLoupe(diamondAddress)
            .facetAddress(UNDO_SELECTOR);

        bytes4[] memory selectors = IDiamondLoupe(diamondAddress)
            .facetFunctionSelectors(undoAddress);

        bool found;
        for (uint i = 0; i < selectors.length; i++) {
            if (selectors[i] == UNDO_SELECTOR) {
                found = true;
                break;
            }
        }

        assertTrue(found, "Undo selector not found");
    }

}


contract PublicTest2 is TestUndo {

    string PATH = "test/data/cuts.json";
    string KEY = ".undoAdd";
    constructor() TestUndo(PATH, KEY) { }

    function test_undo_add() external {
        _executeTest();
    }
}

contract PublicTest3 is TestUndo {

    string PATH = "test/data/cuts.json";
    string KEY = ".undoRemove";
    constructor() TestUndo(PATH, KEY) { }

    function test_undo_remove() external {
        _executeTest();
    }
}

contract PublicTest4 is TestUndo {

    string PATH = "test/data/private/cuts.json";
    string KEY = ".undoReplace";
    constructor() TestUndo(PATH, KEY) { }

    function test_undo_replace() external {
        _executeTest();
    }
}

contract PublicTest5 is TestUndo {

    string PATH = "test/data/private/cuts.json";
    string KEY = ".undoMultiple";
    constructor() TestUndo(PATH, KEY) { }

    function test_allow_multiple_undos() external {
        _executeTest();
    }
}
