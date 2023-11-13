// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../helpers/DiamondHelpers.sol";
import "../../../contracts/facets/HeadFacet.sol";

interface Undo {
    function undo() external;
}

abstract contract TestUndo is Test {

    using stdJson for string;

    enum TestAction { Cut, Undo }
    
    bytes32 CUT_EVENT_HASH = 0x8faa70878671ccd212d20771b795c50af8fd3ff6cf27f4bde57e5d4de0aeb673;
    IDiamondCut diamondCut;
    IDiamondLoupe diamondLoupe;

    address[] facets;
    mapping(address => uint256) salts;

    uint256 numSteps;
    string jsonData;
    string testDataKey;

    struct EncodedFacetCut {
        IDiamondCut.FacetCutAction action;
        uint256 facetId;
        string[] functions;
    }

    constructor(string memory _testDataPath, string memory _testDataKey) {
        jsonData = vm.readFile(_testDataPath);
        testDataKey = _testDataKey;

        numSteps = jsonData.readUint(string.concat(testDataKey, ".numSteps"));
        
        facets.push(address(0)); // Dummy value for zero addresses
        uint256[5] memory saltArr = [uint256(15), 7654, 6992131, 25891, 2389232];
        for (uint i = 0; i < 5; i++) {
            address facet = address(new HeadFacet(saltArr[i]));
            facets.push(facet);
            salts[facet] = saltArr[i];
        }

        address diamondAddress = DiamondHelpers.deploy();

        diamondCut = IDiamondCut(diamondAddress);
        diamondLoupe = IDiamondLoupe(diamondAddress);
    }

    function _executeTest() internal {
        for (uint i = 0; i < numSteps; i++) {
            (TestAction action, IDiamondCut.FacetCut[] memory cuts) = _readStep(i);

            if (action == TestAction.Cut) {
                diamondCut.diamondCut(cuts, address(0), "");
            } else {
                _assertUndo(cuts);
            }
        }
    }

    function _assertUndo(IDiamondCut.FacetCut[] memory _expectedCuts) private {
        vm.recordLogs();
        Undo(address(diamondCut)).undo();
        
        IDiamondCut.FacetCut[] memory actualCuts = _getRecordedCuts();

        for (uint i = 0; i < _expectedCuts.length; i++) {
            IDiamondCut.FacetCut memory cut = _expectedCuts[i];
            assertTrue(
                DiamondHelpers.contains(actualCuts, cut), 
                "Missing facet cut"
            );

            bool expectedSuccess   
                = (cut.action != IDiamondCut.FacetCutAction.Remove);

            (bool success, bytes memory data) = address(diamondCut)
                .call(abi.encodePacked(cut.functionSelectors[0]));

            assertEq(success, expectedSuccess, "Unexpected selector call");
            if (success) {
                uint256 returnValue = abi.decode(data, (uint256));
                assertEq(returnValue, salts[cut.facetAddress], "Unexpected selector call");
            }
        }

    }

    function _readStep(uint256 _i) private returns (TestAction, IDiamondCut.FacetCut[] memory) {

        require(_i < 10, "TEST ERROR: Too many input steps");
        string memory indexKey = "[\u0000]";

        assembly {
            let w := mload(add(indexKey, 0x20))
            w := or(w, shl(240, add(0x30, _i)))
            mstore(add(indexKey, 0x20), w)
        }

        string memory key = string.concat(testDataKey, ".steps",  indexKey);

        EncodedFacetCut[] memory encodedCuts = abi.decode(
            jsonData.parseRaw(string.concat(key, ".cuts")),
            (EncodedFacetCut[])
        );

        TestAction action = TestAction(
            uint8(jsonData.readUint(string.concat(key, ".action"))
        ));

        return (action, _decode(encodedCuts));
        
    }

    function _decode(EncodedFacetCut[] memory _encodedCuts) private view returns (IDiamondCut.FacetCut[] memory) {
        
        IDiamondCut.FacetCut[] memory decodedCuts
            = new IDiamondCut.FacetCut[](_encodedCuts.length);

        for (uint i = 0; i < decodedCuts.length; i++) {
            EncodedFacetCut memory encoded = _encodedCuts[i];

            bytes4[] memory selectors = new bytes4[](encoded.functions.length);
            for (uint j = 0; j < selectors.length; j++) {
                selectors[j] = bytes4(
                    keccak256(abi.encodePacked(encoded.functions[j]))
                );
            }
            
            decodedCuts[i] = IDiamondCut.FacetCut({
                facetAddress: facets[encoded.facetId],
                action: encoded.action,
                functionSelectors: selectors
            });
        }

        return decodedCuts;

    }

    function _getRecordedCuts() private returns (IDiamondCut.FacetCut[] memory) {
        Vm.Log[] memory logs = vm.getRecordedLogs();
        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](100);

        uint256 ctr = 0;
        for (uint i = 0; i < logs.length; i++) {
            if (logs[i].topics[0] != CUT_EVENT_HASH) continue;

            (IDiamondCut.FacetCut[] memory foundCuts,,) = abi.decode(
                logs[i].data,
                (IDiamondCut.FacetCut[], address, bytes)
            );

            for (uint j = 0; j < foundCuts.length; j++) {
                cuts[ctr++] = foundCuts[j];
            }
        }

        assembly { mstore(cuts, ctr) }
        return cuts;
    }


}
