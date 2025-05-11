#!/bin/bash

# Check if Vault is installed
if ! command -v vault &> /dev/null; then
    echo "Vault is not installed. Please install Vault first."
    exit 1
fi

# Function to check if Vault is running
check_vault_running() {
    curl -s http://127.0.0.1:8200/v1/sys/health > /dev/null 2>&1
    return $?
}

# Start Vault server in dev mode if not running
if ! check_vault_running; then
    echo "Starting Vault server in dev mode..."
    # Start Vault in the background and capture its PID
    vault server -dev > vault.log 2>&1 &
    VAULT_PID=$!
    
    # Wait for Vault to be ready
    echo "Waiting for Vault to start..."
    for i in {1..30}; do
        if check_vault_running; then
            break
        fi
        sleep 1
    done
    
    # Extract the root token from the log file
    ROOT_TOKEN=$(grep "Root Token:" vault.log | awk '{print $3}')
    
    if [ -z "$ROOT_TOKEN" ]; then
        echo "Error: Could not find root token in Vault output"
        kill $VAULT_PID
        exit 1
    fi
    
    # Save the token to a file for later use
    echo "$ROOT_TOKEN" > .vault-token
    
    echo "Vault started with root token: $ROOT_TOKEN"
    echo "Token saved to .vault-token"
fi

# Set Vault address and token
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=$(cat .vault-token)

# Verify Vault is accessible
if ! vault status > /dev/null 2>&1; then
    echo "Error: Cannot connect to Vault. Please check if Vault is running."
    exit 1
fi

# Function to check if a secrets engine is enabled
check_secrets_engine() {
    local engine=$1
    vault secrets list | grep -q "^$engine/"
    return $?
}

# Enable AWS secrets engine if not already enabled
echo "Checking AWS secrets engine..."
if ! check_secrets_engine "aws"; then
    echo "Enabling AWS secrets engine..."
    vault secrets enable aws || {
        echo "Error: Failed to enable AWS secrets engine. Please check Vault permissions."
        exit 1
    }
else
    echo "AWS secrets engine is already enabled"
fi

# Configure AWS credentials
echo "Configuring AWS credentials..."
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "Error: AWS credentials not set. Please set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables."
    exit 1
fi

vault write aws/config/root \
    access_key=$AWS_ACCESS_KEY_ID \
    secret_key=$AWS_SECRET_ACCESS_KEY \
    region=us-west-2 || {
    echo "Error: Failed to configure AWS credentials in Vault."
    exit 1
}

# Create AWS role
echo "Creating AWS role..."
vault write aws/roles/aws-role \
    credential_type=iam_user \
    policy_document=-<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "vpc:*",
                "iam:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF || {
    echo "Error: Failed to create AWS role in Vault."
    exit 1
}

# Enable KV secrets engine for GCP if not already enabled
echo "Checking KV secrets engine..."
if ! check_secrets_engine "kv"; then
    echo "Enabling KV secrets engine..."
    vault secrets enable -version=2 kv || {
        echo "Error: Failed to enable KV secrets engine. Please check Vault permissions."
        exit 1
    }
else
    echo "KV secrets engine is already enabled"
fi

# Store GCP credentials
echo "Storing GCP credentials..."
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "Error: GCP credentials file path not set. Please set GOOGLE_APPLICATION_CREDENTIALS environment variable."
    exit 1
fi

vault kv put secret/gcp \
    credentials=@$GOOGLE_APPLICATION_CREDENTIALS || {
    echo "Error: Failed to store GCP credentials in Vault."
    exit 1
}

echo "Vault setup completed successfully!"
echo "Make sure to set the VAULT_TOKEN environment variable:"
echo "export VAULT_TOKEN=$(cat .vault-token)" 