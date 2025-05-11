#!/bin/bash

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd $TEMP_DIR

# Download Vault
echo "Downloading Vault..."
curl -O https://releases.hashicorp.com/vault/1.15.2/vault_1.15.2_darwin_amd64.zip

# Unzip the file
echo "Extracting Vault..."
unzip vault_1.15.2_darwin_amd64.zip

# Move vault to /usr/local/bin
echo "Installing Vault..."
sudo mv vault /usr/local/bin/

# Clean up
cd -
rm -rf $TEMP_DIR

# Verify installation
echo "Verifying Vault installation..."
vault version

echo "Vault has been installed successfully!" 