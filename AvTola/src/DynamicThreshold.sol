// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicThreshold {
    uint256 public threshold = 1 ether; // Default threshold
    
    event ThresholdUpdated(uint256 newThreshold);

    function adjustThreshold(uint256 percentageBelowThreshold) external {
        if (percentageBelowThreshold > 50) {
            // Decrease threshold by 5%
            threshold = threshold * 95 / 100;
        } else if (percentageBelowThreshold < 50) {
            // Increase threshold by 5%
            threshold = threshold * 105 / 100;
        }
        // If it's exactly 50%, we don't change the threshold

        emit ThresholdUpdated(threshold);
    }

    function getThreshold() public view returns (uint256) {
        return threshold;
    }
}