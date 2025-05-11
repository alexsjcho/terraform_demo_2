#!/bin/bash

# Create vault-data directory if it doesn't exist
mkdir -p vault-data

# Start Vault server
vault server -config=vault/config.hcl > vault/vault.log 2>&1 &

# Wait for Vault to start
sleep 5

# Initialize Vault
INIT_RESPONSE=$(vault operator init -key-shares=1 -key-threshold=1 -format=json)

# Extract the root token and unseal key
UNSEAL_KEY=$(echo $INIT_RESPONSE | jq -r '.unseal_keys_b64[0]')
ROOT_TOKEN=$(echo $INIT_RESPONSE | jq -r '.root_token')

# Unseal Vault
vault operator unseal $UNSEAL_KEY

# Save the tokens to a file
echo "VAULT_ADDR=http://127.0.0.1:8200" > .env
echo "VAULT_TOKEN=$ROOT_TOKEN" >> .env
echo "UNSEAL_KEY=$UNSEAL_KEY" >> .env

echo "Vault has been initialized and unsealed!"
echo "Root Token: $ROOT_TOKEN"
echo "Unseal Key: $UNSEAL_KEY"
echo "These values have been saved to .env file"
echo "You can access the Vault UI at http://127.0.0.1:8200/ui" 