locals {
  # Common configuration
  common_config = {
    tags = {
      Environment = "demo"
      Project     = "terraform-multicloud"
      ManagedBy   = "terraform"
    }
  }

  # AWS configuration
  aws_config = {
    region = "us-west-2"
    vpc_cidr = "10.0.0.0/16"
    public_subnet = "10.0.1.0/24"
    private_subnet = "10.0.2.0/24"
    instance_type = "t2.micro"
    ami_id = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
    security = {
      allowed_ports = [22, 80, 443]
      allowed_cidrs = ["0.0.0.0/0"]
    }
  }

  # GCP configuration
  gcp_config = {
    project_id = "terraform-se-demo"  # GCP project ID
    region = "us-central1"
    network_name = "demo-network"
    subnet_cidr = "10.1.0.0/24"
    machine_type = "e2-micro"
    image_family = "debian-11"
    security = {
      allowed_ports = [22, 80, 443]
      allowed_cidrs = ["0.0.0.0/0"]
    }
  }
} 