// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GuardAlarm {

    bool public solved;

    function trigger(address _guard) external {
        bytes memory _calldata = abi.encodeWithSignature("activate()");

        // Trigger false alarm.
        (bool success, bytes memory data) = _guard.staticcall(_calldata);
        require(success, "False alarm failed");
        bool result = abi.decode(data, (bool));
        require(!result, "Guard shouldn't activate!");

        // Trigger real alarm. This is not a drill!
        (success, data) = _guard.call(_calldata);
        require(success, "Real alarm failed");
        result = abi.decode(data, (bool));
        require(result, "Guard shouldn't activate!");

        solved = true;
    }

}
