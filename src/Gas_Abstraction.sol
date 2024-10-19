// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GasAbstraction is Ownable (msg.sender) {
    uint256 public gasThreshold;  // Dynamic threshold for small vs large transactions
    uint256 public liquidityPool;  // Contract's liquidity pool

    // Event to track gas payments
    event GasPaid(address indexed user, uint256 gasUsed, bool isSmallTx);

    constructor() {
        liquidityPool = 1 ether;  // Start with some liquidity
        gasThreshold = 0.1 ether;  // Initial threshold (can be dynamically updated)
    }

    // Modifier to check if the contract has enough liquidity
    modifier hasLiquidity() {
        require(liquidityPool > 0, "No liquidity available");
        _;
    }

    // Pay gas for small transactions
    function payGasForSmallTx() external payable hasLiquidity {
        require(msg.value <= gasThreshold, "Transaction exceeds gas threshold");
        uint256 gasUsed = tx.gasprice * gasleft(); // Calculate gas used
        require(liquidityPool >= gasUsed, "Insufficient liquidity");

        liquidityPool -= gasUsed;  // Deduct gas from liquidity pool
        emit GasPaid(msg.sender, gasUsed, true);
    }

    // Charge extra gas for large transactions
    function chargeExtraGasForLargeTx() external payable {
        require(msg.value > gasThreshold, "Transaction is below gas threshold");
        
        uint256 gasUsed = tx.gasprice * gasleft(); // Calculate gas used
        uint256 extraGas = gasUsed * 2;  // Charge extra
        require(msg.value >= extraGas, "Insufficient gas for large transaction");

        liquidityPool += extraGas - gasUsed;  // Replenish pool
        emit GasPaid(msg.sender, extraGas, false);
    }

    // Allow external service to update the gas threshold
    function updateThreshold(uint256 newThreshold) external onlyOwner {
        gasThreshold = newThreshold;
    }

    // Deposit more liquidity to the pool
    function depositLiquidity() external payable {
        liquidityPool += msg.value;
    }

    // Withdraw funds (owner only)
    function withdrawFunds(uint256 amount) external onlyOwner {
        require(amount <= liquidityPool, "Not enough liquidity");
        liquidityPool -= amount;
        payable(owner()).transfer(amount);
    }
}
