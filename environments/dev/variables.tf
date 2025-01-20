# environments/dev/variables.tf

variable "github_token" {
  description = "GitHub token for ArgoCD"
  type        = string
  sensitive   = true
}

variable "gitops_repo_url" {
  description = "URL of the GitOps repository"
  type        = string
}

variable "gitops_repo_branch" {
  description = "Branch of the GitOps repository to use"
  type        = string
  default     = "main"
}

# Your existing variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"  # Mumbai region
}