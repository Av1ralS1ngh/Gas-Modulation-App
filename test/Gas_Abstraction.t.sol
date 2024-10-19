// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Gas_Abstraction.sol";
import "forge-std/console.sol";

contract GasAbstractionTest is Test {
    GasAbstraction gasAbstraction;
    address owner = address(1);
    address user = address(2);

    function setUp() public {
        vm.startPrank(owner);
        gasAbstraction = new GasAbstraction();
        vm.stopPrank();
    }

    function testDepositLiquidity() public {
        vm.deal(owner, 2 ether);
        vm.startPrank(owner);
        
        gasAbstraction.depositLiquidity{value: 1 ether}();
        
        assertEq(gasAbstraction.liquidityPool(), 2 ether);  // Updated expectation
        vm.stopPrank();
    }

    function testPayGasForSmallTx() public {
        vm.deal(owner, 1 ether);
        gasAbstraction.depositLiquidity{value: 1 ether}();
        vm.deal(user, 0.05 ether);
        vm.startPrank(user);

        gasAbstraction.payGasForSmallTx{value: 0.05 ether}();
        
        uint256 gasUsed = tx.gasprice * gasleft();
        assertEq(gasAbstraction.liquidityPool(), 2 ether - gasUsed);  // Updated expectation
        vm.stopPrank();
    }

    function testChargeExtraGasForLargeTx() public {
        vm.deal(owner, 1 ether);
        gasAbstraction.depositLiquidity{value: 1 ether}();
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        gasAbstraction.chargeExtraGasForLargeTx{value: 0.5 ether}();

        uint256 gasUsed = tx.gasprice * gasleft();
        uint256 extraGas = gasUsed * 2;
        uint256 expectedLiquidity = 2 ether + (extraGas - gasUsed);  // Updated calculation
        
        assertEq(gasAbstraction.liquidityPool(), expectedLiquidity);
        vm.stopPrank();
    }

    function testUpdateThreshold() public {
        vm.startPrank(owner);
        gasAbstraction.updateThreshold(0.2 ether);
        assertEq(gasAbstraction.gasThreshold(), 0.2 ether);
        vm.stopPrank();
    }

function testWithdrawFunds() public {
    // Check initial state
    console.log("Initial liquidity pool:", gasAbstraction.liquidityPool());
    console.log("Initial owner balance:", owner.balance);

    // Deposit liquidity
    vm.deal(owner, 1 ether);
    vm.prank(owner);
    gasAbstraction.depositLiquidity{value: 1 ether}();
    
    console.log("Liquidity pool after deposit:", gasAbstraction.liquidityPool());
    console.log("Owner balance after deposit:", owner.balance);

    uint256 initialOwnerBalance = owner.balance;
    
    // Attempt withdrawal
    vm.prank(owner);
    gasAbstraction.withdrawFunds(0.5 ether);

    console.log("Liquidity pool after withdrawal:", gasAbstraction.liquidityPool());
    console.log("Owner balance after withdrawal:", owner.balance);

    // Assertions
    assertEq(gasAbstraction.liquidityPool(), 1.5 ether);  // Assuming 1 ether initial + 1 ether deposit - 0.5 ether withdrawal
    assertEq(owner.balance, initialOwnerBalance + 0.5 ether);
}
    function testWithdrawFailWithoutEnoughLiquidity() public {
    vm.startPrank(owner);
    
    // The contract already has 1 ether from the constructor
    // Let's try to withdraw more than that without depositing more
    vm.expectRevert("Not enough liquidity");
    gasAbstraction.withdrawFunds(1.1 ether);
    
    vm.stopPrank();
}
}