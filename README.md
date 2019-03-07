# kyber-collateral-liquidation
Using the Kyber network for on-chain collateral liquidation in loans.

A web interface for visualising what's going on is provided [here](https://github.com/bengineer19/kyberloan-frontend).

Note: this a proof-of-concept demo.

## Running Ganache
To make the Kyber smart contracts available locally, we use the setup described [here](https://github.com/KyberNetwork/workshop).

```bash
ganache-cli --accounts 20 --defaultBalanceEther 1000 --mnemonic "gesture rather obey video awake genuine patient base soon parrot upset lounge" --networkId 5777 --debug
```

## Deploying Kyber contracts to local Ganache network
To provide Kyber Network functionality to test with on the local ganache network, deploy the contracts from the [Kyber workshop](https://github.com/KyberNetwork/workshop) repo.

Simply run 
```bash
truffle migrate --network development
```

## Note
The main thing in this repo that's important is the `Loan.sol` file. Most other things are development gubbins.
The meat of the demo is in the [front-end repo](https://github.com/bengineer19/kyberloan-frontend).
