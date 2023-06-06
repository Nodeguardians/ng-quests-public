// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "contracts/sEVM.sol";
import "contracts/Test/utils/StaticCaller.sol";
import "contracts/Test/utils/Callee.sol";

abstract contract TestStaticCall is Test {
    sEVM sevm;
    address origin = address(this);
    address callee;
    address caller;

    modifier EOA() {
        vm.startPrank(origin, origin);
        _;
        vm.stopPrank();
    }

    function setUp() public EOA {
        sevm = new sEVM();
        sevm.createAccount(origin, 1);

        callee = sevm.getNextDeploymentAddress(origin);

        sevm.execute(
            Core.Input({
                caller: origin,
                to: address(0),
                value: 0,
                data: abi.encodePacked(type(Callee).creationCode, uint256(1))
            })
        );

        assertEq(sevm.readAccountStorageAt(callee, 0), bytes32(uint256(1)));

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: callee,
                value: 0,
                data: abi.encodeWithSignature("value()")
            })
        );

        assertEq(rdata, abi.encode(uint256(1)));

        caller = sevm.getNextDeploymentAddress(origin);

        sevm.execute(
            Core.Input({
                caller: origin,
                to: address(0),
                value: 0,
                data: abi.encodePacked(
                    type(StaticCaller).creationCode,
                    abi.encode(callee)
                )
            })
        );

        bytes memory bytecode = sevm.getAccountBytecode(caller);
        assertEq(bytecode, abi.encodePacked(type(StaticCaller).runtimeCode));
    }

    function test_StaticCall_View_Without_Value() external EOA {
        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 0,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("callView()")
                )
            })
        );

        assertEq(rdata, abi.encode(uint256(1)));
    }

    function test_Cannot_StaticCall_View_Function_With_Value() external EOA {
        vm.expectRevert();
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 1,
                data: abi.encodeWithSignature(
                    "statiicCall(bytes)",
                    abi.encodeWithSignature("callView()")
                )
            })
        );
    }

    function test_StaticCall_Pure_Without_Value() external EOA {
        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 0,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("callPure()")
                )
            })
        );

        assertEq(rdata, abi.encode(uint256(1)));
    }

    function test_Cannot_StaticCall_Pure_Function_With_Value() external EOA {
        vm.expectRevert();
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 1,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("callPure()")
                )
            })
        );
    }

    function test_Cannot_StaticCall_Non_Payable_With_Value() external EOA {
        vm.expectRevert();
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 1,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("call(uint256)", 5)
                )
            })
        );
    }

    function test_Forward_Revert_Reason() external EOA {
        vm.expectRevert("This function should revert");
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 0,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("callPureRevert()")
                )
            })
        );
    }

    function test_Invalid_Signature() external EOA {
        vm.expectRevert();
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 0,
                data: new bytes(4)
            })
        );
    }

    function test_Cannot_StaticCall_A_State_Changing_Function() external EOA {
        vm.expectRevert("sEVM: read only");
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 0,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("call(uint256)", 5)
                )
            })
        );
    }

    function test_Cannot_StaticCall_With_More_Value_Than_Balance()
        external
        EOA
    {
        vm.expectRevert("sEVM: insufficient balance");
        sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 2,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("call(uint256)", 5)
                )
            })
        );
    }

    function test_Cannot_StaticCall_From_Outside_The_sEVM() external {
        vm.expectRevert("sEVM: msg.sender must be sEVM");
        sevm.staticCall(
            ICrossTx.InternalInput({
                origin: origin,
                caller: origin,
                delegator: address(0),
                to: caller,
                value: 0,
                data: new bytes(0)
            })
        );
    }

    function test_Cannot_Change_The_State_While_Context_Is_ReadOnly() external {
        vm.prank(address(sevm));
        vm.expectRevert("sEVM: read only");
        sevm.staticCall(
            ICrossTx.InternalInput({
                origin: origin,
                caller: origin,
                delegator: address(0),
                to: callee,
                value: 0,
                data: abi.encodeWithSignature("call(uint256)", 5)
            })
        );
    }

    function test_Context() external {
        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: caller,
                value: 0,
                data: abi.encodeWithSignature(
                    "staticCall(bytes)",
                    abi.encodeWithSignature("getContext()")
                )
            })
        );

        assertEq(rdata, abi.encode(origin, caller, callee, callee));
    }
}
