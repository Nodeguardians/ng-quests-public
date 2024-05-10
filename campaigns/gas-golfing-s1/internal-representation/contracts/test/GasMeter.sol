// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../Challenge.sol";

interface HuffGasMeter {
    function meterCall(
        address _target, 
        bytes memory _calldata
    ) external returns (uint256 gas, bytes memory result);
}

contract GasMeter {

    /// @dev Output of: huffc --evm-version paris -b contracts/test/HuffGasMeter.huff
    bytes constant _HUFF_GAS_METER_BYTECODE = (
        hex"60a98060093d393df360003560e01c8063abe770f2146100205780632b73eefa1461006457600080fd5b36600460003760005131505a6000600060405160606000515afa905a60800190036000523d600060603e610053573d6060fd5b60406020523d6040523d6060016000f35b36600460003760005131505a600060006040516060346000515af1905a60820190036000523d600060603e610098573d6060fd5b60406020523d6040523d6060016000f3"
    );

    Challenge public challenge;
    HuffGasMeter public huffGasMeter;
    uint256 public output;

    // Note: Do not modify order of struct members
    // lexically ordered for Foundry compatibility
    struct StoredBoard {
        string board;
        bytes32 id;
    }

    constructor() {
        challenge = new Challenge();
        
        bytes memory huffBytecode = _HUFF_GAS_METER_BYTECODE;
        HuffGasMeter _huffGasMeter;
        assembly {
            _huffGasMeter := create(0, add(huffBytecode, 0x20), mload(huffBytecode))
        }
        require(address(_huffGasMeter) != address(0), "Failed to deploy HuffGasMeter");
        huffGasMeter = _huffGasMeter;
    }

    function measureGas(
        StoredBoard[] calldata boards
    ) external returns (uint256 gas) {

        uint256 totalGas = 0;
        for (uint256 i = 0; i < boards.length; i++) {
            StoredBoard calldata board = boards[i];
            (uint256 gasConsumed, ) = huffGasMeter.meterCall(
                address(challenge),
                abi.encodeWithSelector(Challenge.recordBoard.selector, board.id, board.board)
            );

            totalGas += gasConsumed;
        }

        for (uint256 i = 0; i < boards.length; i++) {
            StoredBoard calldata board = boards[i];
            string memory result = challenge.getBoard(board.id);
            require(
                keccak256(bytes(result)) == keccak256(bytes(board.board)), 
                "Unexpected result"
            );
        }

        output = totalGas / boards.length;
        
        return output;
    }

}
