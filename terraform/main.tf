terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "azuread" {
  tenant_id = var.tenant_id
}

data "azuread_client_config" "current" {}

locals {
  normalized_github_repos = sort(distinct(var.github_repos))

  effective_tenant_id = coalesce(var.tenant_id, data.azuread_client_config.current.tenant_id)

  effective_application_display_name = coalesce(
    var.application_display_name,
    "waterapps-github-actions-azure-bootstrap"
  )

  effective_role_assignment_scopes = length(var.role_assignment_scopes) > 0 ? var.role_assignment_scopes : [
    "/subscriptions/${var.subscription_id}"
  ]

  main_branch_federated_credentials = [
    for repo in local.normalized_github_repos : {
      key          = "${repo}-main"
      display_name = substr("${repo}-main", 0, 120)
      description  = "GitHub Actions OIDC for ${repo} main branch"
      subject      = "repo:${var.github_org}/${repo}:ref:refs/heads/${var.github_default_branch}"
    }
  ]

  pull_request_federated_credentials = var.enable_pull_request_subjects ? [
    for repo in local.normalized_github_repos : {
      key          = "${repo}-pull-request"
      display_name = substr("${repo}-pr", 0, 120)
      description  = "GitHub Actions OIDC for ${repo} pull_request"
      subject      = "repo:${var.github_org}/${repo}:pull_request"
    }
  ] : []

  environment_federated_credentials = [
    for cfg in var.github_environment_subjects : {
      key          = "${cfg.repo}-environment-${cfg.environment}"
      display_name = substr("${cfg.repo}-${cfg.environment}", 0, 120)
      description  = "GitHub Actions OIDC for ${cfg.repo} environment ${cfg.environment}"
      subject      = "repo:${var.github_org}/${cfg.repo}:environment:${cfg.environment}"
    }
  ]

  federated_credentials = {
    for cred in concat(
      local.main_branch_federated_credentials,
      local.pull_request_federated_credentials,
      local.environment_federated_credentials
    ) : cred.key => cred
  }

  role_assignment_pairs = flatten([
    for scope in local.effective_role_assignment_scopes : [
      for role_name in var.role_definition_names : {
        key                  = "${md5("${scope}|${role_name}")}"
        scope                = scope
        role_definition_name = role_name
      }
    ]
  ])

  role_assignments = {
    for pair in local.role_assignment_pairs : pair.key => pair
  }
}

resource "azuread_application" "github_actions" {
  display_name = local.effective_application_display_name
  owners       = var.application_owner_object_ids
}

resource "azuread_service_principal" "github_actions" {
  client_id = azuread_application.github_actions.client_id
  owners    = var.service_principal_owner_object_ids
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  for_each = local.federated_credentials

  application_id = azuread_application.github_actions.id
  display_name   = each.value.display_name
  description    = each.value.description
  audiences      = var.oidc_audiences
  issuer         = var.oidc_issuer_url
  subject        = each.value.subject
}

resource "azurerm_role_assignment" "github_actions" {
  for_each = local.role_assignments

  scope                            = each.value.scope
  role_definition_name             = each.value.role_definition_name
  principal_id                     = azuread_service_principal.github_actions.object_id
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}
