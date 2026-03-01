output "tenant_id" {
  description = "Azure tenant ID used for the bootstrap resources"
  value       = local.effective_tenant_id
}

output "subscription_id" {
  description = "Azure subscription ID used for RBAC assignments"
  value       = var.subscription_id
}

output "application_client_id" {
  description = "Client ID for the Entra application used by GitHub Actions OIDC"
  value       = azuread_application.github_actions.client_id
}

output "application_object_id" {
  description = "Object ID for the Entra application registration"
  value       = azuread_application.github_actions.object_id
}

output "service_principal_object_id" {
  description = "Object ID for the service principal used in RBAC assignments"
  value       = azuread_service_principal.github_actions.object_id
}

output "federated_identity_subjects" {
  description = "Federated identity credential subjects created for GitHub Actions"
  value = {
    for key, cred in local.federated_credentials : key => cred.subject
  }
}

output "role_assignment_plan" {
  description = "Requested RBAC role assignments for the service principal"
  value = [
    for pair in local.role_assignment_pairs : {
      scope                = pair.scope
      role_definition_name = pair.role_definition_name
    }
  ]
}

output "github_actions_workflow_config" {
  description = "Values to copy into GitHub repo/environment configuration for Azure OIDC login"
  value = {
    github_secret_name_client_id = "AZURE_CLIENT_ID"
    github_var_name_tenant_id    = "AZURE_TENANT_ID"
    github_var_name_subscription = "AZURE_SUBSCRIPTION_ID"
    client_id                    = azuread_application.github_actions.client_id
    tenant_id                    = local.effective_tenant_id
    subscription_id              = var.subscription_id
  }
}
