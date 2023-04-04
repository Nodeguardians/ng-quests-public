// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../../../contracts/CursedGrimoires.sol";

contract TestCursedGrimoires is Test {

    using stdJson for string;

    struct InputWallet {
        address addr;
        bytes32 privateKey;
        bytes32 publicKeyX;
        bytes32 publicKeyY;
    }

    struct InputTransfer {
        bytes32 publishedX;
        bytes32 publishedY;
        uint256 secret;
        address stealthAddress;
        uint256 tokenId;
    }

    InputTransfer transfer;
    InputWallet recipient;

    CursedGrimoires grimoires;

    constructor(
        string memory _testDataPath, 
        string memory _testDataKey
    ) {
        string memory jsonData = vm.readFile(_testDataPath);

        string memory recipientKey = string.concat(_testDataKey, ".recipient");
        recipient = abi.decode(
            jsonData.parseRaw(recipientKey),
            (InputWallet)
        );

        string memory transferKey = string.concat(_testDataKey, ".transfer");
        transfer = abi.decode(
            jsonData.parseRaw(transferKey),
            (InputTransfer)
        );

        grimoires = new CursedGrimoires();
    }

    function test_register_valid_public_keys() external {
        hoax(recipient.addr);
        grimoires.register(recipient.publicKeyX, recipient.publicKeyY);
    }

    function test_not_register_invalid_public_keys() external {
        vm.expectRevert();
        hoax(recipient.addr);
        grimoires.register(recipient.publicKeyY, recipient.publicKeyX);
    }

    function test_compute_stealth_address() external {
        hoax(recipient.addr);
        grimoires.register(recipient.publicKeyX, recipient.publicKeyY);

        (address stealthAddr, bytes32 publishedX, bytes32 publishedY)
            = grimoires.getStealthAddress(recipient.addr, transfer.secret);

        assertEq(publishedX, transfer.publishedX, "Unexpected result");
        assertEq(publishedY, transfer.publishedY, "Unexpected result");
        assertEq(stealthAddr, transfer.stealthAddress, "Unexpected result");
    }

    function test_revert_if_getting_stealth_addresses_of_unregistered_recipients() external {
        vm.expectRevert();
        grimoires.getStealthAddress(recipient.addr, transfer.secret);
    }

    function test_print() external {
        grimoires.print(recipient.addr, transfer.tokenId);
        assertEq(
            grimoires.ownerOf(transfer.tokenId), 
            recipient.addr,
            "Incorrect Owner"
        );
    }

    function test_stealthTransfer() external {
        grimoires.print(address(this), transfer.tokenId);

        vm.recordLogs();
        grimoires.stealthTransfer(
            transfer.stealthAddress,
            transfer.tokenId,
            transfer.publishedX,
            transfer.publishedY
        );

        Vm.Log memory log = _getStealthTransferLog();
        assertEq(
            abi.encode(log.topics[1]),
            abi.encode(transfer.stealthAddress), 
            "Event recipient incorrect"
        );
        assertEq(
            log.data, 
            abi.encode(transfer.publishedX, transfer.publishedY),
            "Event published data incorrect"
        );

        assertEq(
            grimoires.ownerOf(transfer.tokenId),
            transfer.stealthAddress,
            "NFT not transferred"
        );
    }

    function _getStealthTransferLog() private returns (Vm.Log memory) {

        Vm.Log[] memory logs = vm.getRecordedLogs();
        bytes32 expectedHash = keccak256(bytes("StealthTransfer(address,bytes32,bytes32)"));

        for (uint256 i = 0; i < logs.length; i++) {
            if (logs[i].topics[0] != expectedHash) { continue; }
            
            return logs[i];
        }
        
        revert("No StealthTransfer event emitted");
    }

}