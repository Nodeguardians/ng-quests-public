// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../../../contracts/PaymentChannel.sol";
import "../../../contracts/interfaces/IPaymentChannel.sol";
import "forge-std/Test.sol";

abstract contract TestPaymentChannel is Test {
    using stdJson for string;

    IPaymentChannel paymentChannel;

    address sender;
    uint256 senderKey;
    address receiver;
    uint256 receiverKey;

    struct Input {
        uint256 paymentAmount;
        uint256 time;
        uint256 totalFunds;
    }

    Input input;
    bytes signature;

    constructor(string memory _testDataPath, string memory _testDataKey) {
        string memory jsonData = vm.readFile(_testDataPath);

        input = abi.decode(jsonData.parseRaw(_testDataKey), (Input));
        (receiver, receiverKey) = makeAddrAndKey("receiver");
        (sender, senderKey) = makeAddrAndKey("sender");
    }

    function setUp() public {
        hoax(sender, input.totalFunds);
        paymentChannel = IPaymentChannel(address(
            new PaymentChannel{value: input.totalFunds}(
                payable(receiver),
                input.time
            )
        ));

        bytes memory message = abi.encodePacked(
            "\x19Ethereum Signed Message:\n52",
            address(paymentChannel),
            input.paymentAmount
        );

        bytes32 unsignedHash = keccak256(message);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(senderKey, unsignedHash);
        signature = abi.encodePacked(r, s, v);
    }

    function test_sendMoney() external {
        uint initReceiverBalance = receiver.balance;
        uint initSenderBalance = sender.balance;

        vm.prank(receiver);
        paymentChannel.closeChannel(
            input.paymentAmount,
            signature
        );

        assertEq(
            receiver.balance, 
            initReceiverBalance + input.paymentAmount
        );
        assertEq(
            sender.balance,
            initSenderBalance + (input.totalFunds - input.paymentAmount)
        );
        assertFalse(paymentChannel.isActive());
    }

    function test_badSignature_fail() external {
        vm.expectRevert();
        vm.prank(receiver);
        paymentChannel.closeChannel(
            input.paymentAmount - 1,
            signature
        );
    }

    function test_acceptMoreThanOneMessage_fail() external {
        vm.startPrank(receiver);
        paymentChannel.closeChannel(input.paymentAmount, signature);

        vm.expectRevert();
        paymentChannel.closeChannel(input.paymentAmount, signature);
        vm.stopPrank();
    }

    function test_onlyReceiverClosesChannel() external {
        vm.expectRevert();
        vm.prank(sender);
        paymentChannel.closeChannel(input.paymentAmount, signature);
    }

    function test_timeOut() external {

        // Should not time out before expiration
        vm.expectRevert();
        vm.prank(sender);
        paymentChannel.timeOut();

        skip(input.time + 1);

        // After expiration, receiver cannot close channel
        vm.expectRevert();
        vm.prank(receiver);
        paymentChannel.closeChannel(input.paymentAmount, signature);
        
        // timeout() should return all funds to sender
        uint256 initSenderBalance = sender.balance;
        vm.prank(sender);
        paymentChannel.timeOut();

        assertEq(sender.balance, initSenderBalance + input.totalFunds);
        assertFalse(paymentChannel.isActive());
    }

    function test_extendTime() external {

        vm.startPrank(sender);
        paymentChannel.addTime(input.time);

        skip(input.time + 1);

        vm.expectRevert();
        paymentChannel.timeOut();

        skip(input.time + 1);
        paymentChannel.timeOut();

        assertFalse(paymentChannel.isActive());
    }
}
