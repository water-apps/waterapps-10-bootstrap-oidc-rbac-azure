variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "water-apps"
}

variable "github_repos" {
  description = "Repositories allowed to use OIDC federation"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.github_repos) > 0
    error_message = "Set at least one GitHub repository in github_repos."
  }
}

variable "github_default_branch" {
  description = "Default GitHub branch used for branch-based OIDC subjects"
  type        = string
  default     = "main"
}

variable "enable_pull_request_subjects" {
  description = "Create pull_request OIDC federated credential subjects for each repo"
  type        = bool
  default     = true
}

variable "github_environment_subjects" {
  description = "Additional environment-based OIDC subjects (for GitHub Environments like production)"
  type = list(object({
    repo        = string
    environment = string
  }))
  default = []
}

variable "application_display_name" {
  description = "Optional Entra ID application display name override"
  type        = string
  default     = null
}

variable "application_owner_object_ids" {
  description = "Optional Entra object IDs to assign as owners of the application registration"
  type        = list(string)
  default     = []
}

variable "service_principal_owner_object_ids" {
  description = "Optional Entra object IDs to assign as owners of the service principal"
  type        = list(string)
  default     = []
}

variable "tenant_id" {
  description = "Azure tenant ID (optional if discoverable from az login)"
  type        = string
  default     = null
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL for GitHub Actions"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "oidc_audiences" {
  description = "Allowed audiences for federated credentials"
  type        = list(string)
  default     = ["api://AzureADTokenExchange"]
}

variable "role_definition_names" {
  description = "Role definition names to assign to the GitHub Actions service principal"
  type        = list(string)
  default     = ["Reader"]
}

variable "role_assignment_scopes" {
  description = "Scopes to assign roles at. Defaults to the subscription scope when empty."
  type        = list(string)
  default     = []
}

variable "skip_service_principal_aad_check" {
  description = "Skip AAD principal lookup during role assignment creation to avoid propagation timing issues"
  type        = bool
  default     = true
}

variable "subscription_id" {
  description = "Azure subscription ID for RBAC assignments"
  type        = string
}
