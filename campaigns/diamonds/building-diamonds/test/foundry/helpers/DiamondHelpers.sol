// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../../../contracts/facets/DiamondCutFacet.sol";
import "../../../contracts/facets/DiamondLoupeFacet.sol";
import "../../../contracts/facets/OwnershipFacet.sol";
import "../../../contracts/Diamond.sol";

library DiamondHelpers {

    function deploy() internal returns (address diamondAddress) { 
        address cutLogic = address(new DiamondCutFacet());
        Diamond diamond = new Diamond(address(this), cutLogic);

        address loupeLogic = address(new DiamondLoupeFacet());
        address ownershipLogic = address(new OwnershipFacet());

        IDiamondCut diamondCut = IDiamondCut(address(diamond));

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](2);

        // Add Diamond Loupe Facet
        bytes4[] memory loupeSelectors = new bytes4[](4);
        loupeSelectors[0] = IDiamondLoupe.facets.selector;
        loupeSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
        loupeSelectors[2] = IDiamondLoupe.facetAddresses.selector;
        loupeSelectors[3] = IDiamondLoupe.facetAddress.selector;

        cut[0] = IDiamondCut.FacetCut({
            facetAddress: loupeLogic,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: loupeSelectors
        });

        // Add Ownership Facet
        bytes4[] memory ownershipSelectors = new bytes4[](2);
        ownershipSelectors[0] = IERC173.owner.selector;
        ownershipSelectors[1] = IERC173.transferOwnership.selector;
        cut[1] = IDiamondCut.FacetCut({
            facetAddress: ownershipLogic,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: ownershipSelectors
        });

        diamondCut.diamondCut(cut, address(0), "");
        return address(diamond);
    }

    function initialSelectors() internal pure returns (bytes4[7] memory) {
        return [
            IDiamondLoupe.facets.selector,
            IDiamondLoupe.facetFunctionSelectors.selector,
            IDiamondLoupe.facetAddresses.selector,
            IDiamondLoupe.facetAddress.selector,
            IDiamondCut.diamondCut.selector,
            IERC173.owner.selector,
            IERC173.transferOwnership.selector
        ];
    }

    function contains(
        IDiamondCut.FacetCut[] memory cuts, 
        IDiamondCut.FacetCut memory queryCut
    ) internal pure returns (bool) {
        for (uint i = 0; i < cuts.length; i++) {
            if (cuts[i].facetAddress != queryCut.facetAddress
                || cuts[i].action != queryCut.action) { continue; }
            
            for (uint j = 0; j < cuts[i].functionSelectors.length; j++) {
                if (cuts[i].functionSelectors[j] 
                    == queryCut.functionSelectors[0]) { 
                    return true; 
                }
            }
        }
        return false;
    }

    function equals(
        bytes4[] memory actual, 
        bytes4[] memory expected
    ) internal pure returns (bool) {
        return _checksum(actual) == _checksum(expected);
    }

    function _checksum(bytes4[] memory _selectors) private pure returns (bytes4)  {
        bytes4 checksum = bytes4(0);
        for (uint i = 0; i < _selectors.length; i++) {
            checksum = checksum ^ _selectors[i]; 
        }
        return checksum;
    }
    
}