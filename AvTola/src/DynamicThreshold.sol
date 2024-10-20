// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicThreshold {
    uint256 public threshold = 0.00000000000002 ether;  // Default threshold
    
    event ThresholdUpdated(uint256 newThreshold);
    event PercentageBelowThresholdReceived(uint256 percentage);

    function adjustThreshold(uint256 percentageBelowThreshold) external {
        emit PercentageBelowThresholdReceived(percentageBelowThreshold);  // Emit event for tracking

        if (percentageBelowThreshold > 65) {
            // Decrease threshold by 5%
            threshold = threshold * 98 / 100;
        } else if (percentageBelowThreshold < 65) {
            // Increase threshold by 5%
            threshold = threshold * 102 / 100;
        }
        // If it's exactly 75%, we don't change the threshold

        emit ThresholdUpdated(threshold);  // Emit event after updating
    }

    function getThreshold() public view returns (uint256) {
        return threshold;
    }
}
