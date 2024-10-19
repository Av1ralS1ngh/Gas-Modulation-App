import { ethers } from "ethers";
import liquidityPoolABI from "../abi/LiquidityPool.json";
import dynamicThresholdABI from "../abi/DynamicThreshold.json";
import deployedContracts from "../deployedContracts.json";  // Auto-generated addresses

export const getContract = (contractName, signer) => {
  let abi, address;

  if (contractName === "LiquidityPool") {
    abi = liquidityPoolABI.abi;  // Path to your ABI
    address = deployedContracts.LiquidityPool;  // Auto-generated address
  } else if (contractName === "DynamicThreshold") {
    abi = dynamicThresholdABI.abi;  // Path to your ABI
    address = deployedContracts.DynamicThreshold;  // Auto-generated address
  }

  return new ethers.Contract(address, abi, signer);
};
