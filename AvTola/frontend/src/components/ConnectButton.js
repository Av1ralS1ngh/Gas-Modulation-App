import React, { useContext } from "react";
import { WalletContext } from "../context/WalletContext";

const ConnectButton = () => {
  const { connectWallet, connected } = useContext(WalletContext);

  return (
    <div>
      {!connected ? (
        <button onClick={connectWallet}>Connect to Metamask</button>
      ) : (
        <p>Wallet Connected</p>
      )}
    </div>
  );
};

export default ConnectButton;