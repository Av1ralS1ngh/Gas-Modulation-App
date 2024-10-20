// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DynamicThreshold {
    uint256 public threshold = 0.000000000000002 ether;  // Default threshold
    
    event ThresholdUpdated(uint256 newThreshold);
    event PercentageBelowThresholdReceived(uint256 percentage);

    function adjustThreshold(uint256 percentageBelowThreshold) external {
        emit PercentageBelowThresholdReceived(percentageBelowThreshold);  // Emit event for tracking

        if (percentageBelowThreshold > 75) {
            // Decrease threshold by 5%
            threshold = threshold * 95 / 100;
        } else if (percentageBelowThreshold < 75) {
            // Increase threshold by 5%
            threshold = threshold * 105 / 100;
        }
        // If it's exactly 75%, we don't change the threshold

        emit ThresholdUpdated(threshold);  // Emit event after updating
    }

    function getThreshold() public view returns (uint256) {
        return threshold;
    }
}
