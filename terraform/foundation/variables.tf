variable "region" {
  default = "ca-central-1"
}

variable "environment" {
  default = "coffee-plz"
}

variable "cidr_block" {
  description = "CIDR block for VPC."
  default     = "10.0.0.0/16"
}
