# Operations Runbook

Status: Draft v1  
Last updated: 2026-03-01

## Purpose

Operate and troubleshoot Azure OIDC bootstrap trust and RBAC assignments used by CI/CD.

## Routine Operations

1. Review failed Azure OIDC logins in GitHub Actions.
2. Verify federated credential subject coverage for active repos/branches/environments.
3. Audit RBAC role assignments for least privilege.
4. Reconcile outputs with downstream repo configuration.

## Incident Triage

1. OIDC authentication failure:
   - check subject mismatch
   - check tenant/client/subscription IDs in repo config
2. Authorization failure after login:
   - verify role assignment scope and propagation delay
3. Unexpected access scope:
   - inspect RBAC assignments and remove excess roles

## Escalation

1. `P1` (multi-repo CI outage): CTO + platform security lead.
2. `P2` (single repo onboarding issue): repo maintainer + platform engineer.

## Recovery Checklist

1. Root cause documented with impacted repos.
2. Terraform correction merged/applied.
3. Downstream CI rerun successful.
4. Follow-up preventive control recorded.
