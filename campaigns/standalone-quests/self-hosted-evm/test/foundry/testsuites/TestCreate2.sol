// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "forge-std/Test.sol";
import "forge-std/StdUtils.sol";
import "contracts/sEVM.sol";
import "contracts/test/helpers/Create2.sol";
import "contracts/test/helpers/CreatedParams.sol";
import "contracts/test/helpers/CreatedNoParams.sol";

abstract contract TestCreate2 is Test {
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
                data: type(Create2).creationCode
            })
        );

        bytes memory bytecode = sevm.getAccountBytecode(create);
        assertEq(bytecode, abi.encodePacked(type(Create2).runtimeCode));
    }

    function test_Create2_No_Parameters_And_No_Value() external EOA {
        uint256 salt = 1;
        bytes32 codeHash = keccak256(type(CreatedNoParams).creationCode);
        address created = computeCreate2Address(
            bytes32(salt),
            codeHash,
            create
        );

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create2(bytes,uint256)",
                    type(CreatedNoParams).creationCode,
                    salt
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

    function test_Create2_No_Parameters_And_Value() external EOA {
        uint256 salt = 2;
        bytes32 codeHash = keccak256(type(CreatedNoParams).creationCode);
        address created = computeCreate2Address(
            bytes32(salt),
            codeHash,
            create
        );

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 1,
                data: abi.encodeWithSignature(
                    "create2(bytes,uint256)",
                    type(CreatedNoParams).creationCode,
                    salt
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

    function test_Create2_Parameters_And_No_Value() external EOA {
        uint256 salt = 3;
        bytes32 codeHash = keccak256(
            abi.encodePacked(type(CreatedParams).creationCode, uint256(2))
        );
        address created = computeCreate2Address(
            bytes32(salt),
            codeHash,
            create
        );

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create2(bytes,uint256)",
                    abi.encodePacked(
                        type(CreatedParams).creationCode,
                        uint256(2)
                    ),
                    salt
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

    function test_Create2_Parameters_And_Value() external EOA {
        uint256 salt = 4;
        bytes32 codeHash = keccak256(
            abi.encodePacked(type(CreatedParams).creationCode, uint256(2))
        );
        address created = computeCreate2Address(
            bytes32(salt),
            codeHash,
            create
        );

        bytes memory rdata = sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 1,
                data: abi.encodeWithSignature(
                    "create2(bytes,uint256)",
                    abi.encodePacked(
                        type(CreatedParams).creationCode,
                        uint256(2)
                    ),
                    salt
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
        uint256 salt = 5;

        vm.expectRevert();
        sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create2(bytes, uint256)",
                    type(CreatedParams).creationCode,
                    salt
                )
            })
        );
    }

    function test_Cannot_Create2_If_Account_Already_Exists() external EOA {
        uint256 salt = 6;
        bytes32 codeHash = keccak256(
            abi.encodePacked(type(CreatedParams).creationCode, uint256(2))
        );
        address created = computeCreate2Address(
            bytes32(salt),
            codeHash,
            create
        );
        sevm.createAccount(created, 0);

        vm.expectRevert("sEVM: account already exists");
        sevm.execute(
            Core.Input({
                caller: origin,
                to: create,
                value: 0,
                data: abi.encodeWithSignature(
                    "create2(bytes,uint256)",
                    abi.encodePacked(
                        type(CreatedParams).creationCode,
                        uint256(2)
                    ),
                    salt
                )
            })
        );
    }

    function test_Cannot_Create2_While_Context_Is_ReadOnly() external {
        vm.prank(address(sevm));
        vm.expectRevert("sEVM: read only");
        sevm.create2(
            ICrossTx.InternalInput({
                origin: origin,
                caller: origin,
                delegator: address(0),
                to: address(0),
                value: 0,
                data: new bytes(0)
            }),
            true,
            0
        );
    }
}
