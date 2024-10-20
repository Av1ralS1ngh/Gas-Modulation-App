const axios = require('axios');
const EventEmitter = require('events');
const ALCHEMY_URL = 'https://eth-sepolia.g.alchemy.com/v2/qwKU_mQH3ujxhGMcOtdUkkBUOUIvlyk-';
let THRESHOLD = 0.000000000000002; // Initial threshold in ETH
class PercentageEmitter extends EventEmitter {}
const percentageEmitter = new PercentageEmitter();

function adjustThreshold(percentage) {
  if (percentage < 75) {
    THRESHOLD *= 1.05; // Increase threshold by 5%
  } else {
    THRESHOLD *= 0.95; // Decrease threshold by 5%
  }
  console.log(`New threshold: ${THRESHOLD} ETH`);
}

async function getTransactionsPercentageBelowThreshold() {
  try {
    const latestBlockResponse = await axios.post(ALCHEMY_URL, {
      jsonrpc: '2.0',
      id: 1,
      method: 'eth_blockNumber',
      params: []
    });
    const latestBlockHex = latestBlockResponse.data.result;
    const previousBlockHex = '0x' + (parseInt(latestBlockHex, 16) - 1).toString(16);
    const blockResponse = await axios.post(ALCHEMY_URL, {
      jsonrpc: '2.0',
      id: 2,
      method: 'eth_getBlockByNumber',
      params: [previousBlockHex, true]
    });
    const block = blockResponse.data.result;
    const totalTransactions = block.transactions.length;
    const transactionsBelowThreshold = block.transactions.filter(tx => {
      const valueInEth = parseInt(tx.value, 16) / 1e18;
      return valueInEth < THRESHOLD;
    });
    const percentageBelowThreshold = totalTransactions > 0 ?
      ((transactionsBelowThreshold.length / totalTransactions) * 100).toFixed(2) :
      0;
    console.log(`Percentage below threshold: ${percentageBelowThreshold}%`);
    
    // Adjust the threshold based on the percentage
    adjustThreshold(parseFloat(percentageBelowThreshold));
    
    // Emit the new percentage
    percentageEmitter.emit('update', percentageBelowThreshold);
  } catch (error) {
    console.error('Error:', error);
  }
}

// Run every second
setInterval(getTransactionsPercentageBelowThreshold, 1000);

// Export the emitter so it can be used in other files
module.exports = percentageEmitter;