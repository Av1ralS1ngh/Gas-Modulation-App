import React from 'react';
import TransactionForm from './components/TransactionForm';
import ThresholdDisplay from './components/ThresholdDisplay';
import { WalletProvider } from './context/WalletContext';
import ConnectButton from './components/ConnectButton';

function App() {
  return (
    <WalletProvider>
      <div className="App">
        <h1>Gas Refund Project</h1>
        <ConnectButton />
        <TransactionForm />
        <ThresholdDisplay />
      </div>
    </WalletProvider>
  );
}

export default App;