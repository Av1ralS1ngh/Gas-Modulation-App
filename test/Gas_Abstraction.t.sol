// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Gas_Abstraction.sol";  // Update path according to your directory structure

contract GasAbstractionTest is Test {
    GasAbstraction gasAbstraction;
    address owner = address(1);  // Simulating owner address
    address user = address(2);   // Simulating user address

    // Run before every test
    function setUp() public {
        vm.startPrank(owner);  // Start using the owner address
        gasAbstraction = new GasAbstraction();
        vm.stopPrank();  // Stop using the owner address
    }

    // Test if the owner can deposit liquidity
    function testDepositLiquidity() public {
        vm.deal(owner, 2 ether);  // Give owner 2 ether
        vm.startPrank(owner);     // Act as the owner
        
        // Deposit 1 ether into the contract
        gasAbstraction.depositLiquidity{value: 1 ether}();
        
        assertEq(gasAbstraction.liquidityPool(), 1 ether);  // Liquidity pool should be updated
        vm.stopPrank();
    }

    // Test if the contract can pay gas for small transactions
    function testPayGasForSmallTx() public {
        vm.deal(owner, 1 ether);  // Give the owner enough ether
        gasAbstraction.depositLiquidity{value: 1 ether}();  // Deposit liquidity
        vm.deal(user, 0.1 ether);  // Give the user 0.1 ether
        vm.startPrank(user);       // Act as the user

        // Simulate a small transaction that the liquidity pool will cover gas for
        gasAbstraction.payGasForSmallTx(); // Only user should be passed as an argument
        
        // Estimate the gas used for the transaction
        uint256 gasUsed = tx.gasprice * gasleft();
        assertEq(gasAbstraction.liquidityPool(), 1 ether - gasUsed);  // Liquidity should be deducted
        vm.stopPrank();
    }

    // Test if the contract charges extra gas for large transactions
    function testChargeExtraGasForLargeTx() public {
        vm.deal(owner, 1 ether);  // Give the owner enough ether
        gasAbstraction.depositLiquidity{value: 1 ether}();  // Deposit liquidity
        vm.deal(user, 1 ether);  // Give the user 1 ether
        vm.startPrank(user);     // Act as the user

        // Simulate a large transaction that will charge extra gas
        gasAbstraction.chargeExtraGasForLargeTx{value: 0.5 ether}();

        // Calculate the gas used for the transaction
        uint256 gasUsed = tx.gasprice * gasleft();
        uint256 expectedLiquidity = 1 ether + gasUsed;  // Liquidity should be replenished by the extra gas charge
        
        assertEq(gasAbstraction.liquidityPool(), expectedLiquidity);  // Liquidity pool should be updated
        vm.stopPrank();
    }

    // Test if the owner can update the threshold
    function testUpdateThreshold() public {
        vm.startPrank(owner);  // Act as the owner

        // Update the threshold
        gasAbstraction.updateThreshold(0.2 ether);

        assertEq(gasAbstraction.gasThreshold(), 0.2 ether);  // Threshold should be updated
        vm.stopPrank();
    }

    // Test if the owner can withdraw funds
    function testWithdrawFunds() public {
        vm.deal(owner, 1 ether);  // Give owner 1 ether
        gasAbstraction.depositLiquidity{value: 1 ether}();  // Deposit liquidity
        vm.startPrank(owner);     // Act as the owner

        // Withdraw 0.5 ether from the liquidity pool
        gasAbstraction.withdrawFunds(0.5 ether);

        assertEq(gasAbstraction.liquidityPool(), 0.5 ether);  // Liquidity should be reduced
        vm.stopPrank();
    }

    // Test if liquidity withdrawal fails when not enough liquidity is present
    function testWithdrawFailWithoutEnoughLiquidity() public {
        vm.startPrank(owner);  // Act as the owner
        
        // Attempt to withdraw more than available liquidity
        gasAbstraction.depositLiquidity{value: 1 ether}();  // Ensure there is liquidity
        vm.expectRevert("Not enough liquidity");
        gasAbstraction.withdrawFunds(2 ether);  // Only 1 ether in pool
        
        vm.stopPrank();
    }
}
