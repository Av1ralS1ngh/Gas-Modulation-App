// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Gas_Abstraction.sol";

contract GasAbstractionScript is Script {
    GasAbstraction public gasAbstraction;
    address public constant OWNER = address(0x1234567890123456789012345678901234567890);
    address public constant USER = address(0x9876543210987654321098765432109876543210);

    constructor() {
        // Deploy the GasAbstraction contract
        gasAbstraction = new GasAbstraction();
    }

    function run() public {
        vm.startBroadcast();
        // Fund the owner and user
        vm.deal(OWNER, 10 ether);
        vm.deal(USER, 10 ether);

        // Deposit liquidity
        vm.startPrank(OWNER);
        gasAbstraction.depositLiquidity{value: 5 ether}();
        vm.stopPrank();

        console.log("Initial liquidity:", gasAbstraction.liquidityPool());

        // Pay gas for small transaction
        vm.startPrank(USER);
        gasAbstraction.payGasForSmallTx{value: 0.05 ether}();
        vm.stopPrank();

        console.log("Liquidity after small transaction:", gasAbstraction.liquidityPool());

        // Charge extra gas for large transaction
        vm.startPrank(USER);
        gasAbstraction.chargeExtraGasForLargeTx{value: 0.5 ether}();
        vm.stopPrank();

        console.log("Liquidity after large transaction:", gasAbstraction.liquidityPool());

        // Update threshold
        vm.startPrank(OWNER);
        gasAbstraction.updateThreshold(0.25 ether);
        console.log("New threshold:", gasAbstraction.gasThreshold());
        vm.stopPrank();

        // Withdraw funds
        vm.startPrank(OWNER);
        gasAbstraction.withdrawFunds(2 ether);
        console.log("Remaining liquidity:", gasAbstraction.liquidityPool());
        vm.stopPrank();

        // Attempt to withdraw too much (this should revert)
        vm.startPrank(OWNER);
        gasAbstraction.withdrawFunds(10 ether);
        vm.stopPrank();
        vm.stopBroadcast();
    }
}
