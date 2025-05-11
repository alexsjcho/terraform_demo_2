variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
}

variable "allowed_ports" {
  description = "List of allowed ports for the security group"
  type        = list(number)
}

variable "allowed_cidrs" {
  description = "List of allowed CIDR blocks for the security group"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
} 