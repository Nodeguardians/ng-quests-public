// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "contracts/sEVM.sol";
import "contracts/Test/utils/Create.sol";
import "contracts/Test/utils/CreatedParams.sol";
import "contracts/Test/utils/CreatedNoParams.sol";

abstract contract TestCreate is Test {
    sEVM sevm;
    address origin = address(this);
    address create;

    modifier EOA() {
        vm.startPrank(origin, origin);
        _;
        vm.stopPrank();
    }

    function setUp() public EOA {
        sevm = new sEVM();
        sevm.createAccount(origin, 1);

        create = sevm.getNextDeploymentAddress(origin);

        sevm.execute(
            Core.Input({
                caller: origin,
                to: address(0),
                value: 0,
                data: type(Create).creationCode
            })
        );

        bytes memory bytecode = sevm.getAccountBytecode(create);
        assertEq(bytecode, abi.encodePacked(type(Create).runtimeCode));
    }

    function test_Create_No_Parameters_And_No_Value() external EOA {
        address created = sevm.getNextDeploymentAddress(create);

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create(bytes)",
                    type(CreatedNoParams).creationCode
                )
            })
        );

        assertEq(rdata, abi.encode(created), "invalid created return address");


        bytes memory bytecode = sevm.getAccountBytecode(created);
        assertEq(
            bytecode,
            abi.encodePacked(type(CreatedNoParams).runtimeCode),
            "invalid created bytecode"
        );

        assertEq(sevm.getAccountNonce(create), 2, "invalid creator nonce");
        assertEq(sevm.getAccountNonce(created), 1, "invalid created nonce");

        rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: created,
                value: 0,
                data: abi.encodeWithSignature("value()")
            })
        );

        assertEq(rdata, abi.encode(uint256(1)), "invalid created value");
    }

    function test_Create_No_Parameters_And_Value() external EOA {
        address created = sevm.getNextDeploymentAddress(create);

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 1,
                data: abi.encodeWithSignature(
                    "create(bytes)",
                    type(CreatedNoParams).creationCode
                )
            })
        );

        assertEq(rdata, abi.encode(created), "invalid created return address");
        

        bytes memory bytecode = sevm.getAccountBytecode(created);
        assertEq(
            bytecode,
            abi.encodePacked(type(CreatedNoParams).runtimeCode),
            "invalid created bytecode"
        );

        assertEq(sevm.getAccountNonce(create), 2, "invalid creator nonce");
        assertEq(sevm.getAccountNonce(created), 1, "invalid created nonce");

        rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: created,
                value: 0,
                data: abi.encodeWithSignature("value()")
            })
        );

        assertEq(rdata, abi.encode(uint256(1)), "invalid created value");

        assertEq(sevm.getAccountBalance(create), 0, "invalid creator balance");
        assertEq(sevm.getAccountBalance(created), 1, "invalid created balance");
    }

    function test_Create_Parameters_And_No_Value() external EOA {
        address created = sevm.getNextDeploymentAddress(create);

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create(bytes)",
                    abi.encodePacked(
                        type(CreatedParams).creationCode,
                        uint256(2)
                    )
                )
            })
        );

        assertEq(rdata, abi.encode(created), "invalid created return address");
        

        bytes memory bytecode = sevm.getAccountBytecode(created);
        assertEq(
            bytecode,
            abi.encodePacked(type(CreatedParams).runtimeCode),
            "invalid created bytecode"
        );

        assertEq(sevm.getAccountNonce(create), 2, "invalid creator nonce");
        assertEq(sevm.getAccountNonce(created), 1, "invalid created nonce");

        rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: created,
                value: 0,
                data: abi.encodeWithSignature("value()")
            })
        );

        assertEq(rdata, abi.encode(uint256(2)), "invalid created value");
    }

    function test_Create_Parameters_And_Value() external EOA {
        address created = sevm.getNextDeploymentAddress(create);

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 1,
                data: abi.encodeWithSignature(
                    "create(bytes)",
                    abi.encodePacked(
                        type(CreatedParams).creationCode,
                        uint256(2)
                    )
                )
            })
        );

        assertEq(rdata, abi.encode(created), "invalid created return address");
        

        bytes memory bytecode = sevm.getAccountBytecode(created);
        assertEq(
            bytecode,
            abi.encodePacked(type(CreatedParams).runtimeCode),
            "invalid created bytecode"
        );

        assertEq(sevm.getAccountNonce(create), 2, "invalid creator nonce");
        assertEq(sevm.getAccountNonce(created), 1, "invalid created nonce");

        rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: created,
                value: 0,
                data: abi.encodeWithSignature("value()")
            })
        );

        assertEq(rdata, abi.encode(uint256(2)), "invalid created value");
        assertEq(sevm.getAccountBalance(create), 0, "invalid creator balance");
        assertEq(sevm.getAccountBalance(created), 1, "invalid created balance");
    }

    function test_Forward_Constructor_Revert() external EOA {
        vm.expectRevert();
        sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create(bytes)",
                    type(CreatedParams).creationCode
                )
            })
        );
    }

    function test_Cannot_Create_If_Account_Already_Exists() external EOA {
        address created = sevm.getNextDeploymentAddress(create);
        sevm.createAccount(created, 0);

        vm.expectRevert("sEVM: account already exists");
        sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create(bytes)",
                    abi.encodePacked(
                        type(CreatedParams).creationCode,
                        uint256(2)
                    )
                )
            })
        );
    }

    function test_Cannot_Create_While_Context_Is_ReadOnly() external {
        vm.prank(address(sevm));
        vm.expectRevert("sEVM: read only");
        sevm.create(
            ICrossTx.InternalInput({
                origin: origin,
                caller: origin,
                delegator: address(0),
                to: address(0),
                value: 0,
                data: new bytes(0)
            }),
            true
        );
    }
}
