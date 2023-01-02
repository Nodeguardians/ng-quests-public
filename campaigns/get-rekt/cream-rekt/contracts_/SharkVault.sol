// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract SharkVault {

    // The Shark charges predatory interest rates...
    uint256 constant public INTEREST_RATE_PERCENT = 1;

    IERC20 immutable public gold;
    IERC20 immutable public seagold;

    struct LoanAccount {
        uint256 depositedGold;
        uint256 borrowedSeagold;
        uint256 lastBlock;
    }

    mapping(address => LoanAccount) private accounts;

    constructor(
        IERC20 _gold,
        IERC20 _seagold
    ) {
        gold =  _gold;
        seagold = _seagold;
    }

    /**
     * @notice Deposit gold as collateral. 
     * @param _amount Amount of gold to deposit.
     * @dev Gold must be approved for transfer beforehand.
     */
    function depositGold(uint256 _amount) external payable {

        accounts[msg.sender].depositedGold += _amount;
        gold.transferFrom(msg.sender, address(this), _amount);

    }

    /**
     * @notice Withdraw gold collateral.
     * @param _amount Amount of gold to withdraw.
     * @dev Any existing seagold loan must still be 
     * sufficiently collateralized.
     */
    function withdrawGold(uint256 _amount) external payable {

        LoanAccount memory account = updatedAccount(msg.sender);
        account.depositedGold -= _amount;

        require(_hasEnoughCollateral(account), "Undercollateralized $SEAGLD loan");
        accounts[msg.sender] = account;

        gold.transfer(msg.sender, _amount);

    }

    /**
     * @notice Borrow seagold.
     * @param _amount Amount of seagold to borrow.
     * @dev Seagold loan have be suffciently collateralized 
     * by previously deposited gold.
     */
    function borrow(uint256 _amount) external {

        LoanAccount memory borrowerAccount = updatedAccount(msg.sender);
        borrowerAccount.borrowedSeagold += _amount;

        // Fail if insufficient remaining balance of $SEAGOLD
        uint256 seagoldBalance = seagold.balanceOf(address(this));
        require(_amount <= seagoldBalance, "Insufficient $SEAGLD to lend");

        // Fail if borrower has insufficient gold collateral
        require(_hasEnoughCollateral(borrowerAccount), "Undercollateralized $SEAGLD loan");

        // Transfer $SEAGOLD and update records
        seagold.transfer(msg.sender, _amount);
        accounts[msg.sender] = borrowerAccount;

    }

    /**
     * @notice Repay borrowed seagold.
     * @param _amount Amount of seagold to repay.
     * @dev Seagold must be approved for transfer beforehand.
     */
    function repay(uint256 _amount) external {

        LoanAccount memory account = updatedAccount(msg.sender);
        account.borrowedSeagold -= _amount;
        accounts[msg.sender] = account;

        seagold.transferFrom(msg.sender, address(this), _amount);

    }

    /**
     * @notice Liquidate an existing undercollateralized loan. 
     * The smart contract effectively seizes the gold collateral.
     * @param _borrower Owner of the loan.
     */
    function liquidate(address _borrower) external {

        LoanAccount memory borrowerAccount = updatedAccount(_borrower);

        require(!_hasEnoughCollateral(borrowerAccount), "Borrower has good collateral");
        delete accounts[_borrower];

    }

    /**
     * @notice Get the loan account of a user, with updated interest.
     * @param _accountOwner Owner of the loan.
     */
    function updatedAccount(
        address _accountOwner
    ) public view returns (LoanAccount memory account) {

        account = accounts[_accountOwner];

        if (account.borrowedSeagold > 0) {
            uint256 blockDelta = block.number - account.lastBlock;
            uint256 interest = account.borrowedSeagold * blockDelta 
                * INTEREST_RATE_PERCENT / 100;

            account.depositedGold = (account.depositedGold >= interest) 
                ? account.depositedGold - interest 
                : 0;
        }

        account.lastBlock = block.number;

    }

    /**
     * @dev Returns true if `_account` is sufficiently collateralized by gold.
     * Collateral ratio => 1 GOLD : 0.75 SEAGOLD
     */
    function _hasEnoughCollateral(LoanAccount memory _account) private pure returns (bool) {

        return (3 * _account.depositedGold >= 4 * _account.borrowedSeagold);
        
    }


}
