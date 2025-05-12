terraform {
  cloud {
    organization = "alexcho-demo"

    workspaces {
      name = "terraform-cli-demo"
    }
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

# Vault Provider
provider "vault" {
  address = var.vault_addr
  token   = var.vault_token
  skip_tls_verify = true  # Only if using self-signed certificates
}

# AWS Provider
provider "aws" {
  region = "us-west-2"
  # Credentials will be fetched from Vault
  access_key = data.vault_generic_secret.aws_creds.data["access_key"]
  secret_key = data.vault_generic_secret.aws_creds.data["secret_key"]
}

# GCP Provider
provider "google" {
  project = var.gcp_project_id
  region  = "us-central1"
  # Credentials will be fetched from Vault
  credentials = jsonencode(data.vault_generic_secret.gcp_creds.data)
}

# Get AWS credentials from Vault
data "vault_generic_secret" "aws_creds" {
  path = "secret/aws"
}

# Get GCP credentials from Vault
data "vault_generic_secret" "gcp_creds" {
  path = "secret/gcp"
}

# AWS EC2 Instance
resource "aws_instance" "demo" {
  ami           = "ami-0735c191cf914754d"  # Amazon Linux 2 in us-west-2
  instance_type = var.aws_instance_type    # Changed from hardcoded t2.micro to variable
  tags = {
    Name = "terraform-demo"
  }
}

# GCP Compute Instance
resource "google_compute_instance" "demo" {
  name         = "terraform-demo"
  machine_type = var.gcp_machine_type     # Changed from hardcoded e2-micro to variable
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }
} 