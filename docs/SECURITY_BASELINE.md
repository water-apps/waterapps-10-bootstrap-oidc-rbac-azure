# Security Baseline

Status: Draft v1  
Last updated: 2026-03-01

## Security Objectives

1. Remove long-lived cloud credentials from CI/CD.
2. Enforce explicit trust boundaries for GitHub workflows.
3. Keep RBAC permissions least-privilege and auditable.

## Baseline Controls

1. OIDC federation with explicit subject patterns.
2. Terraform-managed identity and RBAC as code.
3. Manual review for trust or role scope changes.
4. Principle of least privilege for all role assignments.

## Identity and Access Controls

1. Restrict federated credentials to approved repos/branches/environments.
2. Review subject lists when repos/workflows change.
3. Separate bootstrap admin permissions from runtime deploy permissions.

## Secrets and Data

1. Do not store client secrets for CI unless explicitly required.
2. Keep sensitive tenant/subscription architecture details in private docs.
3. Sanitize logs for identifiers before external sharing.

## Review Cadence

1. Monthly RBAC and subject review.
2. Quarterly bootstrap configuration audit.
3. Immediate review after any auth incident.
