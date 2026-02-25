# waterapps-azure-bootstrap

Terraform bootstrap for GitHub Actions OIDC access into Azure using Entra ID federated credentials and baseline RBAC assignments.

## Public Reference Notice

This repository is a generalized reference implementation for Azure CI/CD bootstrap patterns. Environment-specific values and sensitive operational details should remain private.

## Repository Metadata

- Standard name: `waterapps-10-bootstrap-oidc-rbac-azure`
- Depends on: none
- Provides: GitHub OIDC bootstrap + Azure RBAC baseline for downstream repo CI/CD
- Deploy order: `10`

## Scope (starter scaffold)

- Entra ID application / service principal (or workload identity principal pattern)
- Federated identity credentials for GitHub Actions
- Subscription/resource-group scoped RBAC assignments
- Outputs for downstream repo configuration

## Structure

```text
terraform/
  main.tf
  variables.tf
  outputs.tf
docs/
  bootstrap-sequence.md
.github/workflows/
  terraform-ci.yml
  apply.yml
```
