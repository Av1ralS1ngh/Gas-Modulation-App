# Gas-Modulation-App

A blockchain-based solution for the newbies in the blockchain world, leveraging ERC-4337 Account Abstraction to provide dynamic gas fee management. This project was developed during the Syntax Error Hackathon and focuses on a unique mechanism to subsidize small transactions and charge higher fees for larger ones to maintain a local liquidity pool.

## Features

- **Dynamic Gas Fee Management**: 
  - Small transactions are subsidized using a local liquidity pool.
  - High-value transactions rejuvenate the liquidity pool by charging additional fees.
- **ERC-4337 Account Abstraction**: Utilized for enabling contract-based accounts.
- **Dynamic Threshold Adjustment**: 
  - Transaction thresholds are dynamically set using real-time data from the blockchain.
  - Threshold data is fetched using QuickNode API and integrated seamlessly.
- **Secure and Efficient**: 
  - Gas abstraction ensures optimal user experience with reduced gas burden.
  - The mechanism supports fairness and prevents abuse of subsidies.

## Tech Stack

- **Frontend**: 
  - React for a seamless user interface.
  - JavaScript for dynamic interactions.
- **Backend**: 
  - Solidity smart contracts for transaction handling.
  - Foundry framework for contract development and testing.
- **Blockchain**:
  - Deployed on Sepolia Testnet for testing purposes.
  - Data fetching and analysis using Alchemy Sepolia API.

## Smart Contracts

1. **LiquidityPool.sol**: Manages the local liquidity pool, including deposits and withdrawals.
2. **DynamicThreshold.sol**: Adjusts transaction thresholds dynamically based on blockchain data.

## Project Workflow

1. **Dynamic Threshold Adjustment**:
   - Fetch the latest transaction data using Alchemy Sepolia API.
   - Calculate the threshold based on transaction patterns.

2. **Transaction Handling**:
   - For small transactions: Fees are covered using the liquidity pool.
   - For large transactions: Higher fees are charged to replenish the pool.

3. **Frontend Interaction**:
   - Users interact with the interface to initiate transactions.
   - The 'Transact' button triggers the latest threshold calculation and sends it to the contract.
