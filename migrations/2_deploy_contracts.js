var Loan = artifacts.require("./Loan.sol");

module.exports = function(deployer) {
    const collateral = 3;
    deployer.deploy(Loan, collateral);
    // deployer.deploy(Loan);
};
