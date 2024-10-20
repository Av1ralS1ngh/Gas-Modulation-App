// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/LiquidityPool.sol";
import "../src/DynamicThreshold.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        DynamicThreshold threshold = new DynamicThreshold();
        GasAbstraction pool = new GasAbstraction(address(threshold));

        vm.stopBroadcast();
        // Store deployed contract addresses in a JSON file
        string memory jsonOutput = string(abi.encodePacked(
            '{ "LiquidityPool": "', vm.toString(address(pool)), '", '
            '"DynamicThreshold": "', vm.toString(address(threshold)), '" }'
        ));

        vm.writeJson(jsonOutput, "./frontend/src/deployedContracts.json");

        
    }
}
