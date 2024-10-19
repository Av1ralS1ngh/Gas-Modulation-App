import React, { useState, useEffect } from "react";
import { ethers } from "ethers";

const contractAddress = "YOUR_DYNAMIC_THRESHOLD_CONTRACT_ADDRESS";
const abi = [
  // ABI details for DynamicThreshold contract
];

const ThresholdDisplay = () => {
  const [threshold, setThreshold] = useState(null);

  useEffect(() => {
    const fetchThreshold = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = new ethers.Contract(contractAddress, abi, provider);
      const currentThreshold = await contract.getThreshold();
      setThreshold(ethers.utils.formatEther(currentThreshold));
    };

    fetchThreshold();
  }, []);

  return <div>Current Gas-Free Threshold: {threshold} ETH</div>;
};

export default ThresholdDisplay;