pragma solidity 0.4.18;

import "./Kyber/KyberNetworkProxy.sol";

// Modifier which prices contract
contract priced {
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}

contract Loan is priced {
    
    address public lender;
    address public borrower;

    uint public collateral;
    bool public loanDefaulted;
    bool public collateralProvided = false;
    bool public lenderRegistered = false;

    KyberNetworkProxy public proxy;
    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    event LoanStart(address borrower, uint collateral);
    event LoanFulfilled(uint balance);
    event CollateralProvided();
    event Default();

    /// @dev Contract contstructor
    /// @param _proxy KyberNetworkProxy contract address
    /// @param _collateral The amount of collateral being put up for the loan
    function Loan(KyberNetworkProxy _proxy, uint _collateral) public {
        // The loan is initiated by the borrower
        borrower = msg.sender;

        proxy = _proxy;
        collateral = _collateral;
        // Log the event
        LoanStart(borrower, collateral);
    }

    /// @dev Allow the contact to receive collateral
    function payCollateral() public payable costs(collateral){
        collateralProvided = true;
        CollateralProvided();
    }

    /// Allow the contract creator (Borrower) to withdraw collateral 
    /// if no interest has been received in loan offer.
    /// NOTE: this is different to `returnCollateral` and `siezeCollateral`, 
    /// which are intended to be called by the Lender.
    /// @dev Withdraw collateral from loan and return to Borrower
    function withdrawCollateral() public {
        require(msg.sender == borrower);
        // Do not allow withdrawl of collateral after loan has "started"
        require(lenderRegistered == false);

        borrower.transfer(this.balance);
    }

    /// @dev Accept the loan as a lender (note: requires that collateral has already been put up)
    function registerAsLender() public {
        // Require that collateral has already been put up
        require(collateralProvided);
        lenderRegistered = true;
        lender = msg.sender;
    }

    /// @dev Let the lender sieze the collateral in the event of a loan default
    /// @param token The address of the token to liquify the collateral in
    function siezeCollateral(ERC20 token) public {
        require(msg.sender == lender);

        uint minLiqConversionRate;
        // Get minimum conversion rate
        (minLiqConversionRate,) = proxy.getExpectedRate(ETH_TOKEN_ADDRESS, token, this.balance);

        // Swap ETH to ERC20 token
        uint destLiqAmount = proxy.swapEtherToToken.value(this.balance)(token, minLiqConversionRate);
        // Send the swapped tokens to the destination address
        require(token.transfer(lender, destLiqAmount));
        
        // Log event
        Default();
    }

    /// @dev Mark loan as fulfilled and return collateral to the borrower
    function returnCollateral() public {
        // Can only be initiated by lender
        require(msg.sender == lender);

        borrower.transfer(this.balance);
        // Log event
        LoanFulfilled(this.balance);
    }

    /// For testing!
    function meaningOfLife() public pure returns (uint) {
        return 42;
    }

}
