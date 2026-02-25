variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "water-apps"
}

variable "github_repos" {
  description = "Repositories allowed to use OIDC federation"
  type        = list(string)
  default     = []
}

variable "subscription_id" {
  description = "Azure subscription ID for RBAC assignments"
  type        = string
}
