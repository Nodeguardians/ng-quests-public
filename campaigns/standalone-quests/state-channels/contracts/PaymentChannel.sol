// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IPaymentChannel.sol";

contract PaymentChannel /* is IPaymentChannel */ {

    constructor(address payable _worker, uint256 _time) payable { }
    
}
