# modules/argocd/variables.tf

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "github_token" {
  description = "GitHub personal access token"
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