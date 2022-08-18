// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract TestProbe {

    function delegateCall(address target) external returns (bool) {

        (bool result, bytes memory _returnData) = target.delegatecall(
            abi.encodeWithSignature("isDelegateCall()")
        );

        require(result, "Delegate call failed");
        
        bool isDelegate = abi.decode(_returnData, (bool));

        return isDelegate;

    }

}
