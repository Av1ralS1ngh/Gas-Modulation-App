// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DynamicThreshold.sol";

contract LiquidityPool {
    DynamicThreshold public thresholdContract;
    address owner;

    constructor(address _thresholdAddress) {
        thresholdContract = DynamicThreshold(_thresholdAddress);
        owner = msg.sender;
    }

    function transact(address payable to, uint256 amount) external payable {
        require(msg.value >= amount, "Insufficient payment");

        uint256 threshold = thresholdContract.getThreshold();
        if (amount <= threshold) {
            // Below threshold, refund gas
            uint256 gasRefund = msg.value - amount;
            require(address(this).balance >= gasRefund, "Not enough liquidity for refund");
            to.transfer(amount);
            payable(msg.sender).transfer(gasRefund);
        } else {
            // Above threshold, take small fee
            uint256 fee = (amount * 1) / 100;  // 1% fee
            uint256 netAmount = amount - fee;
            to.transfer(netAmount);
            // Remaining goes to pool
        }
    }

    // To add liquidity for refunds
    function addLiquidity() external payable {
        require(msg.value > 0, "Must add liquidity");
    }

    // Fallback function to receive funds
    receive() external payable {}
}
