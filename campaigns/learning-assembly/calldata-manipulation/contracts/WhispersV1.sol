// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WhispersV1 {

    /// @notice Read and return the uint256 appended behind the expected calldata.
    function whisperUint256() external pure returns (uint256 value) {
        assembly {
        }
    }

    /// @notice Read and return the string appended behind the expected calldata.
    /// @dev The string is abi-encoded.
    function whisperString() external pure returns (string memory str) {
        assembly {

        }
    }

}
