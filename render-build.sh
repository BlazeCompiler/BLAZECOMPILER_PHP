#!/bin/bash
# Install dependencies for PHP and Node.js
echo "Installing dependencies..."
apt-get update
apt-get install -y php-cli php-mbstring

# Install Node.js dependencies
npm install

echo "Dependencies installed successfully."

# Run the server
echo "Starting the server..."
npm start
