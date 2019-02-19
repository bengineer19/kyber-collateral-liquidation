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

    KyberNetworkProxy public proxy;
    ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);

    event LoanStart(address borrower, uint collateral);
    event LoanFulfilled();
    event CollateralProvided();
    event Default();

    //@dev Contract contstructor
    //@param _proxy KyberNetworkProxy contract address
    //@param _collateral The amount of collateral being put up for the loan
    function Loan(KyberNetworkProxy _proxy, uint _collateral) public {
        // The loan is initiated by the borrower
        borrower = msg.sender;

        proxy = _proxy;
        collateral = _collateral;
        // Log the event
        LoanStart(borrower, collateral);
    }

    //@dev Allow the contact to receive collateral
    function payCollateral() public payable costs(collateral){
        collateralProvided = true;
        CollateralProvided();
    }

    //@dev Accept the loan as a lender 
    //     (note: requires that collateral has already been put up)
    function registerAsLender() public {
        // Require that collateral has already been put up
        require(collateralProvided);
        lender = msg.sender;
    }

    //@dev Let the lender sieze the collateral in the event of a loan default
    function siezeCollateral() public {
        require(msg.sender == lender);

        msg.sender.transfer(collateral);
        Default();
    }

    //@dev Allow the lender to mark the loan as fulfilled and return the 
    //     collateral to the borrower
    function withdrawCollateral() public {
        require(msg.sender == lender);

        borrower.transfer(collateral);
        LoanFulfilled();
        // msg.sender.transfer(collateral);
    }

    function meaningOfLife() public pure returns (uint) {
        return 42;
    }

    // TODO: allow borrower to withdraw collateral
    // function cancelLoan(){}

}
