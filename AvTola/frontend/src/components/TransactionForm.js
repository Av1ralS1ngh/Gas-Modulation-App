import React, { useState, useContext } from "react";
import { ethers } from "ethers";
import { WalletContext } from "../context/WalletContext";

const contractAddress = "YOUR_LIQUIDITY_POOL_CONTRACT_ADDRESS";
const abi = [
  // ABI details for LiquidityPool contract
];

const TransactionForm = () => {
  const [amount, setAmount] = useState("");
  const [toAddress, setToAddress] = useState("");
  const { signer } = useContext(WalletContext);

  const handleSubmit = async (e) => {
    e.preventDefault();
    const contract = new ethers.Contract(contractAddress, abi, signer);
    const txValue = ethers.utils.parseEther(amount);
    const transaction = await contract.transact(toAddress, txValue, { value: txValue });
    await transaction.wait();
    alert("Transaction Completed");
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={toAddress}
        onChange={(e) => setToAddress(e.target.value)}
        placeholder="To Address"
      />
      <input
        type="text"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        placeholder="Amount (ETH)"
      />
      <button type="submit">Transact</button>
    </form>
  );
};

export default TransactionForm;