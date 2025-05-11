variable "vault_addr" {
  description = "Address of the Vault server"
  type        = string
  default     = "http://127.0.0.1:8200"
}

variable "vault_token" {
  description = "Token for Vault authentication"
  type        = string
  sensitive   = true
}

variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "aws_instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "gcp_machine_type" {
  description = "GCP Compute Engine machine type"
  type        = string
  default     = "e2-micro"
} 