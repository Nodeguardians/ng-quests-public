// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/SacredTree.sol";

abstract contract TestTree is Test {

    using stdJson for string;

    struct ProofTest {
        address addr;
        bytes32[] proof;
    }

    ProofTest validProof;
    ProofTest invalidProof;
    SacredTree tree;

    constructor(
        string memory _testDataPath,
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);

        string memory validKey = string.concat(_testDataKey, ".valid");
        validProof = abi.decode(
            jsonData.parseRaw(validKey),
            (ProofTest)
        );

        string memory invalidKey = string.concat(_testDataKey, ".invalid");
        invalidProof = abi.decode(
            jsonData.parseRaw(invalidKey),
            (ProofTest)
        );

        tree = new SacredTree();
    }

    function test_verify_proof_correctly() external {

        bool result = tree.verify(
            validProof.addr, 
            validProof.proof
        );

        assertTrue(result, "Unexpected result");
    }

    function test_reject_bad_proof() external {
        bool result = tree.verify(
            invalidProof.addr, 
            invalidProof.proof
        );

        assertTrue(!result, "Unexpected result");

    }

}
