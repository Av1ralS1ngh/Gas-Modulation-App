import React, { useState, useEffect } from "react";
import { getContract } from "../utils/contractConfig";

const ThresholdDisplay = () => {
  const [threshold, setThreshold] = useState(null);

  useEffect(() => {
    const fetchThreshold = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const contract = getContract("DynamicThreshold", provider);
      const currentThreshold = await contract.getThreshold();
      setThreshold(ethers.utils.formatEther(currentThreshold));
    };
    fetchThreshold();
  }, []);

  return <div>Current Gas-Free Threshold: {threshold} ETH</div>;
};

export default ThresholdDisplay;
