// pragma solidity ^0.5.0;
pragma solidity 0.4.18;
/*
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

    uint private collateral;

    bool public loanDefaulted;
    bool public collateralProvided = false;

    event LoanStart(address borrower, uint collateral);
    event LoanFulfilled();
    event CollateralProvided();
    event Default();

    constructor(uint initialCollateral) public {
        // The loan is initiated by the borrower
        borrower = msg.sender;

        collateral = initialCollateral;
        // Log the event
        emit LoanStart(borrower, collateral);
    }

    function payCollateral() public payable costs(collateral){
        // require(msg.sender == borrower);
        collateralProvided = true;
        emit CollateralProvided();
    }

    function registerAsLender() public {
        // Require that collateral has already been put up
        require(collateralProvided);
        lender = msg.sender;
    }

    function withdrawCollateral() public {
        require(loanDefaulted);
        require(msg.sender == lender);

        msg.sender.transfer(collateral);
    }

    function hi() public pure returns (string memory) {
        return ("I'm alive");
    }
}
*/