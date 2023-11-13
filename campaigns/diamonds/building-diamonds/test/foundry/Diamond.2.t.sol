// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "./helpers/DiamondHelpers.sol";
import "../../contracts/facets/HeadFacet.sol";

contract PublicTest1 is Test {

    mapping(bytes4 => bool) expectedSelectors;

    IDiamondCut diamondCut;
    IDiamondLoupe diamondLoupe;

    constructor() { 
        address diamondAddress = DiamondHelpers.deploy();

        diamondCut = IDiamondCut(diamondAddress);
        diamondLoupe = IDiamondLoupe(diamondAddress);
    }

    function test_have_three_facets() external {
        assertEq(diamondLoupe.facetAddresses().length, 3);
    }

    function test_expected_function_selectors() external {
        bytes4[7] memory initSelectors = DiamondHelpers.initialSelectors();
        for (uint i = 0; i < initSelectors.length; i++) {
            expectedSelectors[initSelectors[i]] = true;
        }

        address[] memory facets = diamondLoupe.facetAddresses();

        uint256 ctr = 7;
        for (uint i = 0; i < facets.length; i++) {
            bytes4[] memory selectors = diamondLoupe.facetFunctionSelectors(facets[i]);
            for (uint j = 0; j < selectors.length; j++) {
                if (expectedSelectors[selectors[j]]) {
                    expectedSelectors[selectors[j]] = false;
                    ctr--;
                }
            }
        }

        assertEq(ctr, 0, "Missing selectors");
    }

    function test_selectors_associated_to_facets_correctly() external {
        address[] memory facets = diamondLoupe.facetAddresses();
        assertEq(diamondLoupe.facetAddress(0x1f931c1c), facets[0]);
        assertEq(diamondLoupe.facetAddress(0xcdffacc6), facets[1]);
        assertEq(diamondLoupe.facetAddress(0xf2fde38b), facets[2]);
    }

    function test_add_functions() external {
       address headLogic = address(new HeadFacet(11));

        bytes4[] memory headSelectors = new bytes4[](5);
        headSelectors[0] = HeadFacet.func1.selector;
        headSelectors[1] = HeadFacet.func2.selector;
        headSelectors[2] = HeadFacet.func3.selector;
        headSelectors[3] = HeadFacet.func4.selector;
        headSelectors[4] = HeadFacet.func5.selector;

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: headLogic,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: headSelectors
        });
        diamondCut.diamondCut(cut, address(0), "");

        bytes4[] memory actualSelectors = diamondLoupe.facetFunctionSelectors(headLogic);

        bool isEqual = DiamondHelpers.equals(actualSelectors, headSelectors);
        assertTrue(isEqual, "Unexpected selectors");
        assertEq(
            HeadFacet(address(diamondLoupe)).func1(), 
            11, 
            "New function call failed"
        );
    }

    function test_remove_some_functions() external {

       address headLogic = address(new HeadFacet(11));

        bytes4[] memory headSelectors = new bytes4[](5);
        headSelectors[0] = HeadFacet.func1.selector;
        headSelectors[1] = HeadFacet.func2.selector;
        headSelectors[2] = HeadFacet.func3.selector;
        headSelectors[3] = HeadFacet.func4.selector;
        headSelectors[4] = HeadFacet.func5.selector;

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: headLogic,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: headSelectors
        });
        diamondCut.diamondCut(cut, address(0), "");

        bytes4[] memory toRemove = new bytes4[](3);
        toRemove[0] = HeadFacet.func3.selector;
        toRemove[1] = HeadFacet.func4.selector;
        toRemove[2] = HeadFacet.func5.selector;

        IDiamondCut.FacetCut[] memory removeCut = new IDiamondCut.FacetCut[](1);
        removeCut[0] = IDiamondCut.FacetCut({
            facetAddress: address(0),
            action: IDiamondCut.FacetCutAction.Remove,
            functionSelectors: toRemove
        });
        diamondCut.diamondCut(removeCut, address(0), "");

        bytes4[] memory toKeep = new bytes4[](2);
        toKeep[0] = HeadFacet.func1.selector;
        toKeep[1] = HeadFacet.func2.selector;

        bool isEqual = DiamondHelpers.equals(
            diamondLoupe.facetFunctionSelectors(headLogic), 
            toKeep
        );
        assertTrue(isEqual, "Unexpected selectors");
    }
    
}
