# modules/networking/variables.tf

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type = list(string)
}

variable "tags" {
  description = "Additional tags to be applied to all resources"
  type = map(string)
  default = {}
}

locals {
  mandatory_tags = {
    Owner = "itay-yohanok"
    Bootcamp = "BC22"
    Expiration_date = "30-03-2025"
  }
  # Merge mandatory tags with provided tags, mandatory tags take precedence
  all_tags = merge(var.tags, local.mandatory_tags)
}