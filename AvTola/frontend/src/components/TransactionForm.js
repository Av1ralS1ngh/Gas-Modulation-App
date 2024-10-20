import React, { useState, useContext } from "react";
import { ethers } from "ethers";
import './TransactionForm.css';
import { WalletContext } from "../context/WalletContext";

const TransactionForm = () => {
  const [amount, setAmount] = useState("");
  const [toAddress, setToAddress] = useState("");
  const { signer } = useContext(WalletContext);

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!signer) {
      alert("Please connect your wallet first.");
      return;
    }

    try {
      const txValue = ethers.utils.parseEther(amount); // Convert the entered amount to wei
      const oneLakhWei = ethers.utils.parseUnits("100000", "wei"); // 100,000 wei

      // Check if the amount is more or less than 100,000 wei
      if (txValue.gte(oneLakhWei)) {
        // Show alert for amounts greater than or equal to 100,000 wei
        const proceed = window.confirm("Your amount won't be refunded.");
        if (!proceed) return; // If the user cancels the alert, do not proceed
      } else {
        // Show alert for amounts less than 100,000 wei
        const proceed = window.confirm("Your amount will be refunded.");
        if (!proceed) return; // If the user cancels the alert, do not proceed
      }

      // Create a transaction object
      const transaction = {
        to: toAddress,
        value: txValue,
      };

      // Send the transaction and wait for Metamask to pop up
      const txResponse = await signer.sendTransaction(transaction);

      // Wait for the transaction to be mined
      await txResponse.wait();

      alert("Transaction Completed!");
    } catch (error) {
      console.error(error);
      alert("Transaction failed!");
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={toAddress}
        onChange={(e) => setToAddress(e.target.value)}
        placeholder="Recipient Address"
        required
      />
      <input
        type="text"
        value={amount}
        onChange={(e) => setAmount(e.target.value)}
        placeholder="Amount (ETH)"
        required
      />
      <button type="submit">Transact</button>
    </form>
  );
};

export default TransactionForm;