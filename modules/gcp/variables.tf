variable "network_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_region" {
  description = "Region for the subnet"
  type        = string
}

variable "machine_type" {
  description = "GCP machine type for the compute instance"
  type        = string
}

variable "image_family" {
  description = "GCP image family for the compute instance"
  type        = string
}

variable "allowed_ports" {
  description = "List of allowed ports for the firewall rules"
  type        = list(number)
}

variable "allowed_cidrs" {
  description = "List of allowed CIDR blocks for the firewall rules"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
} 