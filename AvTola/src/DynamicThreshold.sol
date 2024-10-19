// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicThreshold {
    uint256 public threshold = 1 ether;  // Default threshold

    // Example function for dynamically adjusting the threshold
    function adjustThreshold(uint256 newThreshold) external {
        threshold = newThreshold;
    }

    function getThreshold() public view returns (uint256) {
        return threshold;
    }
}
