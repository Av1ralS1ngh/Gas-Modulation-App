import React from 'react';
import TransactionForm from './components/TransactionForm';
import ThresholdDisplay from './components/ThresholdDisplay';
import { WalletProvider } from './context/WalletContext';

function App() {
  return (
    <WalletProvider>
      <div className="App">
        <h1>Gas Refund Project</h1>
        <TransactionForm />
        <ThresholdDisplay />
      </div>
    </WalletProvider>
  );
}

export default App;
