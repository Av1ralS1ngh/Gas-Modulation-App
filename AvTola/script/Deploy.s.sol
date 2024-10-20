// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/LiquidityPool.sol";
import "../src/DynamicThreshold.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        console.log("Starting deployment...");

        console.log("Deploying DynamicThreshold...");
        DynamicThreshold threshold = new DynamicThreshold();
        console.log("DynamicThreshold deployed at:", address(threshold));

        // Check if the contract was deployed successfully
require(address(threshold) != address(0), "DynamicThreshold deployment failed");

        console.log("Deploying GasAbstraction...");
        GasAbstraction pool = new GasAbstraction(address(threshold));
        console.log("GasAbstraction deployed at:", address(pool));

        vm.stopBroadcast();

        console.log("Deployment completed.");

        // Store deployed contract addresses in a JSON file
        string memory jsonOutput = string(abi.encodePacked(
            '{ "LiquidityPool": "', vm.toString(address(pool)), '", ',
            '"DynamicThreshold": "', vm.toString(address(threshold)), '" }'
        ));

        console.log("Writing deployment addresses to JSON file...");
        vm.writeJson(jsonOutput, "./frontend/src/deployedContracts.json");
        console.log("JSON file written successfully.");

        console.log("Deployment script finished.");
    }
}