const axios = require('axios');
const EventEmitter = require('events');
const { Server } = require('socket.io');
const http = require('http');

// Set up a basic HTTP server for Socket.IO
const server = http.createServer();
const io = new Server(server, {
  cors: {
    origin: "http://localhost:3000", // Frontend URL
    methods: ["GET", "POST"]
  }
});

const ALCHEMY_URL = 'https://eth-sepolia.g.alchemy.com/v2/qwKU_mQH3ujxhGMcOtdUkkBUOUIvlyk-';
let THRESHOLD = 0.00000000000002; // Initial threshold in ETH
class PercentageEmitter extends EventEmitter {}
const percentageEmitter = new PercentageEmitter();

function adjustThreshold(percentage) {
  if (percentage < 65) {
    THRESHOLD *= 1.02; // Increase threshold by 5%
  } else {
    THRESHOLD *= 0.98; // Decrease threshold by 5%
  }
  console.log(`New threshold: ${THRESHOLD} ETH`);

  // Emit the new threshold value to the frontend
  io.emit('thresholdUpdate', THRESHOLD); // This emits to all connected clients
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

    // Emit the percentage update event
    percentageEmitter.emit('update', percentageBelowThreshold);
  } catch (error) {
    console.error('Error:', error);
  }
}

// Run the block fetching every second
setInterval(getTransactionsPercentageBelowThreshold, 1000);

// Start the Socket.IO server
server.listen(4000, () => {
  console.log('Socket.IO server running on http://localhost:4000');
});

// Export the emitter for other modules if needed
module.exports = percentageEmitter;