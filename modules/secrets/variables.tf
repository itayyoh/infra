variable "environment" {
  description = "Environment name"
  type        = string
}

variable "github_token" {
  description = "GitHub token value"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

