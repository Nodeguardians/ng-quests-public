// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./EllipticCurve.sol";
import "./FieldElement.sol";

/**
 * @title The Obsidian Gates
 * @dev This contract requires NO MODIFICATION.
 */
contract ObsidianGates {

    event GateOpened();

    mapping(Felt => mapping(Felt => bool)) public keyHolders;
    
    // By signing a salt, we prevent signature replays!
    bytes32 public salt;

    /**
     * @notice Opens the gates if given a valid signature 
     * belonging to a keyholder.
     * @param _signature An NIST P-256 signature.
     */
    function open(
        bytes memory _signature
    ) external {

        (Felt pubKeyX, Felt pubKeyY) 
            = recoverSignature(_signature);

        require(keyHolders[pubKeyX][pubKeyY], "Not a keyholder"); 

        salt = keccak256(abi.encode(salt));
        emit GateOpened();

    }

    /**
     * @notice Recovers a given signature.
     * @param _signature An NIST P-256 signature.
     * @return qx The x-coordinate of the signer's public key.
     * @return qy The y-coordinate of the signer's public key.
     */
    function recoverSignature(
        bytes memory _signature
    ) public view returns (Felt qx, Felt qy) {

        (Felt rx, Felt ry, uint256 s) 
            = abi.decode(_signature, (Felt, Felt, uint256));
        JacPoint memory R = affineToJac(rx, ry);

        JacPoint memory sR = R.jacMul(s);
        JacPoint memory hG = generatePoint(uint256(salt));
    
        return jacToAffine(
            sR.jacAdd(hG).jacMul(Felt.unwrap(R.x.inv()))
        );

    }
}