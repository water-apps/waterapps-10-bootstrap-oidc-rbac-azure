# Bootstrap Sequence (Draft)

1. Authenticate locally to Azure with sufficient rights for Entra ID and RBAC changes.
2. Apply Terraform to create OIDC federation and baseline role assignments.
3. Add required repo/environment variables and secrets in GitHub.
4. Validate CI workflow authentication using OIDC (no client secret).
5. Restrict permissions and scopes after initial verification.
