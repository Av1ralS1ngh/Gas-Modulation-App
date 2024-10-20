import React, { createContext, useState } from "react";
import Web3Modal from "web3modal";
import { ethers } from "ethers";

export const WalletContext = createContext();

export const WalletProvider = ({ children }) => {
  const [provider, setProvider] = useState(null);
  const [signer, setSigner] = useState(null);
  const [connected, setConnected] = useState(false);

  const connectWallet = async () => {
    try {
      const web3Modal = new Web3Modal();
      const connection = await web3Modal.connect();
      const web3Provider = new ethers.providers.Web3Provider(connection);
      setProvider(web3Provider);
      setSigner(web3Provider.getSigner());
      setConnected(true);
    } catch (error) {
      console.error("Wallet connection failed", error);
    }
  };

  return (
    <WalletContext.Provider value={{ provider, signer, connected, connectWallet }}>
      {children}
    </WalletContext.Provider>
  );
};