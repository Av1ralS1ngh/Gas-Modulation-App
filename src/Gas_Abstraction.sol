// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "forge-std/console.sol";

contract GasAbstraction is Ownable(msg.sender) {
    uint256 public gasThreshold; // Dynamic threshold for small vs large transactions
    uint256 public liquidityPool; // Contract's liquidity pool

    // Event to track gas payments
    event GasPaid(address indexed user, uint256 gasUsed, bool isSmallTx);

    constructor() {
        liquidityPool = 1 ether; // Start with some liquidity
        gasThreshold = 0.1 ether; // Initial threshold (can be dynamically updated)
    }

    uint256 threshold = thresholdContract.getThreshold();
    // Modifier to check if the contract has enough liquidity
    modifier hasLiquidity() {
        require(liquidityPool > 0, "No liquidity available");
        _;
    }

    // Pay gas for small transactions
    function payGasForSmallTx(address payable to, uint256 amount) external payable hasLiquidity {
        require(msg.value <= threshold, "Transaction exceeds gas threshold");
        uint256 gasUsed = tx.gasprice * gasleft(); // Calculate gas used
        require(liquidityPool >= gasUsed, "Insufficient liquidity");

        liquidityPool -= gasUsed; // Deduct gas from liquidity pool
        emit GasPaid(msg.sender, gasUsed, true);
        payable(msg.sender).transfer(gasRefund);
        to.transfer(amount);
    }

    // Charge extra gas for large transactions
    function chargeExtraGasForLargeTx(address payable to, uint256 amount) external payable {
    require(msg.value > threshold, "Transaction is below gas threshold");
    
    uint256 fee = (msg.value * 1) / 100; // 1% fee
    uint256 netAmount = msg.value - fee;
    
    uint256 gasUsed = tx.gasprice * gasleft(); // Calculate gas used
    uint256 amountReceived = gasUsed + netAmount; // Charge extra
    
    liquidityPool += amountReceived; // Replenish pool
    
    emit GasPaid(msg.sender, amountReceived, false);
    
    // Transfer net amount to recipient
    to.transfer(amount);
    payable(address(this)).transfer(netAmount);
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
        console.log("Withdraw called with amount:", amount);
        console.log("Current liquidity pool:", liquidityPool);
        console.log("Contract balance:", address(this).balance);
        require(amount <= liquidityPool, "Not enough liquidity");
        liquidityPool -= amount;
        (bool success,) = payable(owner()).call{value: amount}("");
        require(success, "Transfer failed");
        console.log("Transfer completed");
    }
    receive() external payable {}
}

