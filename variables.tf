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