import React, { useState, useEffect } from "react";
import io from "socket.io-client"; // Import Socket.IO client
import './ThresholdDisplay.css';

// Socket.IO connection to the backend server
const socket = io('http://localhost:4000'); // The same URL where your Socket.IO server is running

const ThresholdDisplay = () => {
  const [threshold, setThreshold] = useState(null);

  useEffect(() => {
    // Listen for the 'thresholdUpdate' event from the backend
    socket.on('thresholdUpdate', (newThreshold) => {
      setThreshold(newThreshold); // Update the state with the new threshold value
    });

    // Clean up the socket connection when the component unmounts
    return () => {
      socket.off('thresholdUpdate');
    };
  }, []);

  return <div>Current Gas-Free Threshold: {threshold ? threshold.toFixed(18) : 'Loading...'} ETH</div>;
};

export default ThresholdDisplay;