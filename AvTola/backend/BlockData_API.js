const axios = require('axios');

const ALCHEMY_URL = 'https://eth-sepolia.g.alchemy.com/v2/qwKU_mQH3ujxhGMcOtdUkkBUOUIvlyk-';
const THRESHOLD = 0.1; // Set your threshold in ETH

async function getTransactionsPercentageBelowThreshold() {
  try {
    // Get the latest block number
    const latestBlockResponse = await axios.post(ALCHEMY_URL, {
      jsonrpc: '2.0',
      id: 1,
      method: 'eth_blockNumber',
      params: []
    });
    const latestBlockHex = latestBlockResponse.data.result;
    const previousBlockHex = '0x' + (parseInt(latestBlockHex, 16) - 1).toString(16);

    // Get the previous block
    const blockResponse = await axios.post(ALCHEMY_URL, {
      jsonrpc: '2.0',
      id: 2,
      method: 'eth_getBlockByNumber',
      params: [previousBlockHex, true]
    });
    const block = blockResponse.data.result;

    // Calculate total number of transactions
    const totalTransactions = block.transactions.length;

    // Filter transactions below threshold
    const transactionsBelowThreshold = block.transactions.filter(tx => {
      const valueInEth = parseInt(tx.value, 16) / 1e18;
      return valueInEth < THRESHOLD;
    });

    // Calculate percentage
    const percentageBelowThreshold = totalTransactions > 0 ? 
      ((transactionsBelowThreshold.length / totalTransactions) * 100).toFixed(2) : 
      0;

    console.log(`Total transactions: ${totalTransactions}`);
    console.log(`Transactions below ${THRESHOLD} ETH: ${transactionsBelowThreshold.length}`);
    console.log(`Percentage of transactions below ${THRESHOLD} ETH: ${percentageBelowThreshold}%`);
  } catch (error) {
    console.error('Error:', error);
  }
}

getTransactionsPercentageBelowThreshold();
