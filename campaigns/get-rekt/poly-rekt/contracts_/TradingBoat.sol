// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "./TradingData.sol";

/**
 * @title TradingBoat
 * @notice Contract which manages cross-chain logic.
 * Facilitates cross-chain calls by relaying them to and from
 * other TradingBoat contracts in different chains.
 */
contract TradingBoat {

    using ECDSA for bytes32;

    TradingData public immutable tradingData;
    uint64 internal immutable THIS_CHAIN_ID;

    struct CrossChainCall {
        string method;
        bytes32[] args;
        uint64 fromChainId;
        address fromContract;
        uint64 toChainId;
        address toContract;
    }

    event CrossChainEvent(CrossChainCall crossChainCall);
    
    constructor(address[] memory _trademasters) {
        tradingData = new TradingData();
        tradingData.setTrademasters(_trademasters);

        uint64 _chainId;
        assembly { _chainId := chainid() }
        THIS_CHAIN_ID = _chainId;
    }

    /**
     * @dev Sends a cross-chain call from the current chain to 
     * a destination chain.
     * 
     * The call will take the form:
     * `toContract.{method}(args, THIS_CHAIN_ID, msg.sender)`
     */
    function sendShipment(
        string calldata _method,
        bytes32[] calldata _args,
        uint64 _toChainId,
        address _toContract
    ) external virtual returns (bytes32 bridgeHash) {

        CrossChainCall memory crossChainCall = CrossChainCall({
            method: _method,
            args: _args,
            fromContract: msg.sender,
            fromChainId: THIS_CHAIN_ID,
            toContract: _toContract,
            toChainId: _toChainId
        });

        // (1) Trademaster will read this event and sign the needed signature
        emit CrossChainEvent(crossChainCall);
        
        // (2) Returns the bridge required to query signer on Questplay
        return _bridgeHash(crossChainCall, address(this));

    }

    /**
     * @dev Relays a cross-chain call from a source chain to the current chain.
     * 
     * A trademaster's signature must be provided to verify that the call
     * has indeed originated from the source chain.
     */
    function relayShipment(
        string calldata _method, 
        bytes32[] calldata _args,
        uint64 _fromChainId,
        address _fromContract,
        address _toContract,
        bytes calldata _signature
    ) external {
        
        address fromTradingBoat = tradingData.tradingBoatByChainId(_fromChainId);
        CrossChainCall memory crossChainCall = CrossChainCall({
            fromChainId: _fromChainId,
            fromContract: _fromContract,
            toChainId: THIS_CHAIN_ID,
            toContract: _toContract,
            method: _method,
            args: _args
        });

        // (1) Verify that signature belongs to a trademaster
        address signer = _bridgeHash(crossChainCall, fromTradingBoat)
            .toEthSignedMessageHash()
            .recover(_signature);

        require(
            tradingData.isTrademaster(signer),
            "ERROR: INVALID CROSS-CHAIN SIGNATURE"
        );

        // (2) Call destination contract
        bytes memory functionSig = abi.encodePacked(_method, "(bytes32[],uint64,address)");
        bytes4 selector = bytes4(keccak256(functionSig));

        (bool success, ) = _toContract.call(
            abi.encodeWithSelector(selector, _args, _fromChainId, _fromContract)
        );

        require(success, "ERROR: SHIPMENT TO CLIENT FAILED");
    }

    /**
     * @dev Registers new trademasters. This must be approved by 2 existing trademasters. 
     * @param _newTrademasters New addresses to register as trademasters.
     * @param signatureA Secp256k1 signature by first trademaster.
     * @param signatureB Secp256k1 signature by second trademaster. 
     */
    function setTrademaster(
        address[] calldata _newTrademasters, 
        bytes calldata signatureA,
        bytes calldata signatureB
    ) external {

        // (1) Embed the message with a prefix and chain id
        // This prevents signature replay attacks
        bytes32 signedTrademastersHash = keccak256(
            abi.encode("NEW TRADEMASTERS:", THIS_CHAIN_ID, _newTrademasters)
        ).toEthSignedMessageHash();

        // (2) Ensure that signers are 2 different trademasters
        address signerA = signedTrademastersHash.recover(signatureA);
        address signerB = signedTrademastersHash.recover(signatureB);

        require(signerA != signerB);
        require(tradingData.isTrademaster(signerA) 
            && tradingData.isTrademaster(signerB));

        // (3) Set trademasters in TradingData contract
        tradingData.setTrademasters(_newTrademasters);

    }

    /**
     * @dev Returns the 32-byte bridge hash needed to run `quest bridge` on Questplay.
     * @param _crossChainCall Cross chain call to bridge.
     * @param _fromTradingBoat Address of trading boat in source chain.
     */
    function _bridgeHash(
        CrossChainCall memory _crossChainCall,
        address _fromTradingBoat
    ) internal pure returns (bytes32) {

        // You can safely assume the vulnerability is not here...
        return keccak256(
            abi.encode(_fromTradingBoat, abi.encode(_crossChainCall))
        );

    }

}
