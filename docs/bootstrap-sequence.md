# Bootstrap Sequence

This repo bootstraps an Entra application + service principal, GitHub OIDC federated credentials, and baseline Azure RBAC role assignments.

## Prerequisites

1. Azure CLI authenticated to the correct tenant/subscription (`az login`).
2. Rights to create:
   - Entra app registrations / service principals
   - Federated credentials
   - RBAC role assignments at the target scopes
3. Terraform installed (`>= 1.6` recommended).

## Recommended first bootstrap (local)

The first apply is typically local because the GitHub OIDC identity does not exist yet.

1. Create a `terraform.tfvars` in `terraform/` (example below).
2. Run:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Example `terraform.tfvars`:

```hcl
subscription_id = "00000000-0000-0000-0000-000000000000"
github_org      = "water-apps"
github_repos = [
  "waterapps-10-bootstrap-oidc-rbac-azure",
  "waterapps-20-infra-enterprise-azure",
  "waterapps-25-aks-platform-bicep"
]

github_environment_subjects = [
  { repo = "waterapps-10-bootstrap-oidc-rbac-azure", environment = "production" }
]

role_definition_names = ["Reader"]
```

## Configure GitHub after apply

Copy outputs into repo/environment config:

- Secret: `AZURE_CLIENT_ID`
- Variable: `AZURE_TENANT_ID`
- Variable: `AZURE_SUBSCRIPTION_ID`

These are used by workflows with `azure/login` and `id-token: write`.

## Post-bootstrap workflow usage

- `terraform-ci.yml`: PR/push validation (`fmt`, `init -backend=false`, `validate`)
- `apply.yml`:
  - `plan` for preview
  - `apply` for manual gated apply (`production` environment)

## Hardening next steps

1. Replace broad roles (for example `Reader`) with least-privilege custom or built-in roles per repo.
2. Split RBAC scopes by repo/environment (subscription vs resource-group scope).
3. Add remote backend configuration and protected state storage.
4. Add separate federated credentials for `production` environments only where required.
