const axios = require('axios');
const { ethers } = require('ethers');

// Your Alchemy API URL and private key
const ALCHEMY_URL = 'https://eth-sepolia.g.alchemy.com/v2/qwKU_mQH3ujxhGMcOtdUkkBUOUIvlyk-';
const PRIVATE_KEY = '0961a94f80f7951ba616327d9ec35fcf1679ee0619e85cabe63c5e4ef6d28211';  // Replace with your private key
const CONTRACT_ADDRESS = 'YOUR_CONTRACT_ADDRESS';  // Replace with deployed contract address

// Contract ABI (You can generate it from your compiled contract)
const CONTRACT_ABI = [
  // Add the ABI for the DynamicThreshold contract here
];

// Create provider and wallet
const provider = new ethers.providers.JsonRpcProvider(ALCHEMY_URL);
const wallet = new ethers.Wallet(PRIVATE_KEY, provider);
const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

// Threshold
const THRESHOLD = 0.000000000000002; // Set your threshold in ETH

async function getTransactionsPercentageBelowThreshold() {
  try {
    // Step 1: Fetch the latest block number
    const latestBlockResponse = await axios.post(ALCHEMY_URL, {
      jsonrpc: '2.0',
      id: 1,
      method: 'eth_blockNumber',
      params: []
    });
    const latestBlockHex = latestBlockResponse.data.result;
    const previousBlockHex = '0x' + (parseInt(latestBlockHex, 16) - 1).toString(16);

    // Step 2: Fetch the block data
    const blockResponse = await axios.post(ALCHEMY_URL, {
      jsonrpc: '2.0',
      id: 2,
      method: 'eth_getBlockByNumber',
      params: [previousBlockHex, true]
    });
    const block = blockResponse.data.result;

    // Step 3: Calculate total number of transactions
    const totalTransactions = block.transactions.length;

    // Step 4: Filter transactions below threshold
    const transactionsBelowThreshold = block.transactions.filter(tx => {
      const valueInEth = parseInt(tx.value, 16) / 1e18;
      return valueInEth < THRESHOLD;
    });

    // Step 5: Calculate the percentage
    const percentageBelowThreshold = totalTransactions > 0 ? 
      ((transactionsBelowThreshold.length / totalTransactions) * 100).toFixed(2) : 
      0;

    console.log(`Total transactions: ${totalTransactions}`);
    console.log(`Transactions below ${THRESHOLD} ETH: ${transactionsBelowThreshold.length}`);
    console.log(`Percentage of transactions below ${THRESHOLD} ETH: ${percentageBelowThreshold}%`);

    // Step 6: Send the percentage to the smart contract
    await adjustThresholdInContract(percentageBelowThreshold);
  } catch (error) {
    console.error('Error:', error);
  }
}

// Function to send the percentage to the smart contract
async function adjustThresholdInContract(percentageBelowThreshold) {
  try {
    // Call the adjustThreshold function in the contract
    const tx = await contract.adjustThreshold(percentageBelowThreshold);
    console.log(`Transaction Hash: ${tx.hash}`);

    // Wait for the transaction to be confirmed
    await tx.wait();
    console.log('Threshold adjusted successfully');
  } catch (error) {
    console.error('Error in contract interaction:', error);
  }
}

// Call the function
getTransactionsPercentageBelowThreshold();
